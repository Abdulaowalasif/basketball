import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_endpoin.dart';
import '../../../routes/routes_name.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> forgotPassword() async {
    FocusScope.of(Get.context!).unfocus();

    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Invalid email address');
      return;
    }

    final url = Uri.parse(ApiEndpoints.forgotPassword);

    try {
      isLoading.value = true;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Verification code sent to your email');
        Get.toNamed(RoutesName.verifyCode, arguments: {'email': email});
      } else {
        final errorResponse = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorResponse['detail'] ?? 'Failed to send verification code',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send verification code');
      print('Error in forgotPassword: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
