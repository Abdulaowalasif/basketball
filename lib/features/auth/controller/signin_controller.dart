import 'dart:convert';
import 'package:basketball/features/auth/model/sign_in_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_endpoin.dart';
import '../../../routes/routes_name.dart';
import '../../storage/storage_service.dart';
import '../model/signup_user_model.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;
  RxString accessToken = ''.obs;

  final storageService = Get.put(StorageService());

  @override
  void onInit() {
    super.onInit();
    loadRememberedCredentials();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void signIn() async {
    FocusScope.of(Get.context!).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Invalid email address');
      return;
    }

    final user = LoginRequest(email: email, password: password);
    final url = Uri.parse(ApiEndpoints.login);

    try {
      isLoading.value = true;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Signed in successfully');

        final responseData = jsonDecode(response.body);

        // Store or remove credentials based on rememberMe
        if (rememberMe.value) {
          await storageService.write('email', email);
          await storageService.write('password', password);
          // user_id is not present in the response, so skip storing it
        } else {
          await storageService.remove('email');
          await storageService.remove('password');
        }

        accessToken.value = responseData['access'] ?? '';
        await storageService.write('accessToken', accessToken.value);
        await storageService.write('is_player', responseData['is_player']);

        if (responseData['is_player'] == true) {
          Get.offAllNamed(RoutesName.playerInfo);
        } else {
          Get.offAllNamed(RoutesName.coachInfo);
        }

        clearFields();
      } else {
        try {
          final errorData = jsonDecode(response.body);
          final message = errorData['detail'] ?? 'Sign in failed';
          Get.snackbar('Error', message);
        } catch (_) {
          Get.snackbar('Error', 'Sign in failed');
        }
      }
    } catch (error) {
      Get.snackbar('Error', 'An error occurred: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSignIn() async {
    try {
      isLoading.value = true;

      // Initialize Google Sign-In with server client ID
      await GoogleSignIn.instance.initialize(
        serverClientId: '611353073079-00dtaui4va6r8kh5ubdguga07053n2t5.apps.googleusercontent.com',

      );

      // Check if authentication is supported
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        Get.snackbar('Error', 'Google Sign-In not supported on this platform');
        return;
      }

      // Authenticate the user
      final GoogleSignInAccount? account = await GoogleSignIn.instance.authenticate();
      if (account == null) {
        Get.snackbar('Cancelled', 'Google sign-in cancelled');
        return;
      }

      print('🔐 User signed in: ${account.email}');

      // Define required scopes
      const List<String> scopes = [
        'email',
        'profile',
        'openid', // Required for ID token
      ];

      try {
        // Authorize the scopes to get tokens
        final GoogleSignInClientAuthorization authorization =
        await account.authorizationClient.authorizeScopes(scopes);

        // Get server authorization (this gives you the ID token equivalent)
        final GoogleSignInServerAuthorization? serverAuth =
        await account.authorizationClient.authorizeServer(scopes);

        if (serverAuth == null) {
          Get.snackbar('Error', 'Failed to get Google authorization');
          return;
        }

        final String authCode = serverAuth.serverAuthCode;
        if (authCode.isEmpty) {
          Get.snackbar('Error', 'Failed to get Google auth code');
          return;
        }
        print('🎫 Server Auth Code: $authCode');

        // 🛰️ Send the auth code to your backend
        // Note: You might need to update your backend to handle auth code instead of ID token
        final loginResponse = await http
            .post(
          Uri.parse('${ApiEndpoints.baseUrl}api/auth/google-login/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'auth_code': authCode, // Changed from 'token' to 'auth_code'
            'email': account.email,
            'display_name': account.displayName,
          }),
        )
            .timeout(const Duration(seconds: 10));

        if (loginResponse.statusCode == 200) {
          final responseData = jsonDecode(loginResponse.body);
          print('🔐 Login Success Response: $responseData');
          Get.snackbar('Success', 'Logged in with Google');
          Get.offAllNamed(RoutesName.profile);
        } else {
          print('❌ Login failed: ${loginResponse.body}');
          Get.snackbar(
            'Error',
            'Google login failed (${loginResponse.statusCode})',
          );
        }

      } catch (authError) {
        print('❌ Authorization error: $authError');
        Get.snackbar('Error', 'Failed to authorize Google account');
        return;
      }

    } on GoogleSignInException catch (e) {
      String errorMessage;
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          errorMessage = 'Google sign-in was cancelled';
          break;
        case GoogleSignInExceptionCode.clientConfigurationError:
          errorMessage = 'Google sign-in configuration error';
          break;
        default:
          errorMessage = 'Google sign-in error: ${e.description} (Code: ${e.code})';
      }
      print('❌ GoogleSignInException: $errorMessage');
      Get.snackbar('Error', errorMessage);
    } on PlatformException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'sign_in_canceled':
          errorMessage = 'Google sign-in was cancelled';
          break;
        case 'network_error':
          errorMessage = 'Network error during sign-in';
          break;
        case 'sign_in_failed':
          errorMessage = 'Google sign-in failed: ${e.message}';
          break;
        case 'api_exception':
          errorMessage = 'Google API error: ${e.message}';
          break;
        default:
          errorMessage = 'Platform error: ${e.message} (Code: ${e.code})';
      }
      print('❌ PlatformException: $errorMessage');
      Get.snackbar('Error', errorMessage);
    } catch (e) {
      print('❌ Unexpected error: $e');
      Get.snackbar('Error', 'Unexpected error: $e');
    } finally {
      isLoading.value = false;
    }
  }


  // Placeholder functions for generating unique phone number and password
  String generateUniquePhoneNumber(String email) {
    // Implement logic to generate a unique phone number (e.g., based on email hash)
    return '01${email.hashCode.abs().toString().padLeft(8, '0').substring(0, 8)}';
  }

  String generateSecurePassword() {
    // Implement secure password generation (e.g., random string)
    return 'secure_${DateTime.now().millisecondsSinceEpoch}';
  }

  void loadRememberedCredentials() {
    final hasEmail = storageService.hasData('email');
    final hasPassword = storageService.hasData('password');

    if (hasEmail && hasPassword) {
      emailController.text = storageService.read('email');
      passwordController.text = storageService.read('password');
      rememberMe.value = true;
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
