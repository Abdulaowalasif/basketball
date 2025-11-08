import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_endpoin.dart';
import '../../../routes/routes_name.dart';

class SetNewPasswordController extends GetxController {
  late final String email;
  late final String otp;

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxBool isNewPasswordHidden = true.obs;
  RxBool isConfirmPasswordHidden = true.obs;
  RxBool isLoading = false.obs;

  final url = Uri.parse(ApiEndpoints.setNewPassword);

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments['email'] ?? '';
    otp = Get.arguments['otp'] ?? '';
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void setNewPassword() async {
    FocusScope.of(Get.context!).unfocus();

    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': otp,
          'new_password': newPassword,
          'new_password2': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password updated successfully');
        Get.offNamed(RoutesName.signIn);
      } else {
        Get.snackbar('Error', 'Failed to update password');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }

  }
}
