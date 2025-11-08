import 'dart:convert';
import 'package:basketball/core/constants/user_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_endpoin.dart';
import '../../../routes/routes_name.dart';
import '../model/signup_user_model.dart';

class SignUpController extends GetxController {
  final UserType userType = Get.arguments['userType'];

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    final user = RegisterUser(
      email: emailController.text.trim(),
      fullName:
          '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
      phoneNumber: phoneNumberController.text.trim(),
      isPlayer: userType == UserType.player,
      isCoach: userType == UserType.coach,
      password: passwordController.text,
      password2: confirmPasswordController.text,
    );

    final url = Uri.parse(ApiEndpoints.signUp);

    try {
      isLoading.value = true;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'User registered successfully');
        clearFields();
        Get.offNamed(RoutesName.signIn);
      } else {
        Get.snackbar('Error', 'Failed: ${response.body}');
      }
    } catch (error) {
      Get.snackbar('Error', 'An error occurred: $error');
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
