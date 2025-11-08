import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes_name.dart';
import '../../../widgets/custom_title_appbar.dart';
import '../controller/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTitleAppbar(title: 'Sign Up'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('First Name'),
              TextField(
                controller: signUpController.firstNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your first name here',
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Last Name'),
              TextField(
                controller: signUpController.lastNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your last name here',
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel('Email'),
              TextField(
                controller: signUpController.emailController,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              const SizedBox(height: 16),

              _buildLabel('Phone Number'),
              TextField(
                controller: signUpController.phoneNumberController,
                decoration: const InputDecoration(
                  hintText: 'Enter your phone number',
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel('Password'),
              Obx(
                () => TextField(
                  controller: signUpController.passwordController,
                  obscureText: !signUpController.isPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        signUpController.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: signUpController.togglePasswordVisibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel('Confirm Password'),
              Obx(
                () => TextField(
                  controller: signUpController.confirmPasswordController,
                  obscureText: !signUpController.isConfirmPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        signUpController.isConfirmPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed:
                          signUpController.toggleConfirmPasswordVisibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signUpController.isLoading.value
                        ? null
                        : () => signUpController.registerUser(),
                    child: signUpController.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            "Sign Up",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () => Get.toNamed(RoutesName.signIn),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }
}
