import 'dart:io';

import 'package:basketball/features/auth/controller/signin_controller.dart';
import 'package:basketball/routes/routes_name.dart';
import 'package:basketball/widgets/custom_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController signInController = Get.put(SignInController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTitleAppbar(title: "Sign in"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Email Field
            const Text(
              'Email',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            TextField(
              controller: signInController.emailController,
              decoration: const InputDecoration(hintText: 'Enter your email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password Field
            const Text(
              'Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Obx(
              () => TextField(
                controller: signInController.passwordController,
                obscureText: !signInController.isPasswordVisible.value,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      signInController.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: signInController.togglePasswordVisibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Remember Me & Forgot Password
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: signInController.rememberMe.value,
                        onChanged: (value) {
                          if (value != null) {
                            signInController.rememberMe.value = value;
                          }
                        },
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          color: Colors.orange,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RoutesName.forgotPass);
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: signInController.signIn,
                  child: signInController.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Sign in",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Divider
            const Center(child: Text('Or')),
            const SizedBox(height: 10),

            // // Social Buttons
            // (Platform.isIOS || Platform.isMacOS)
            //     ? _buildSignInButton(
            //   "Sign in with Apple",
            //   "assets/icons/apple_logo.png",
            //       () {},
            // )
            //     : const SizedBox.shrink(),
            // (Platform.isAndroid)
            //     ? _buildSignInButton(
            //   "Sign in with Google",
            //   "assets/icons/google.png",
            //       ()async {
            //     signInController.googleSignIn();
            //   },
            // )
            //     : const SizedBox.shrink(),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                Get.toNamed(RoutesName.compact);
              },
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Don’t have an account? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildSignInButton(
    String text,
    String iconPath,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(iconPath, height: 20),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
