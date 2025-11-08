import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:basketball/widgets/custom_title_appbar.dart';
import '../controller/set_new_pass_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final SetNewPasswordController controller = Get.put(
    SetNewPasswordController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTitleAppbar(title: 'Reset Password'),
      backgroundColor: const Color(0xFFFEF8F4),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set a new password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Create a new password. Ensure it differs from previous ones for security',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 30),

            const Text(
              'Enter new password',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            Obx(
              () => TextField(
                controller: controller.newPasswordController,
                obscureText: controller.isNewPasswordHidden.value,
                decoration: InputDecoration(
                  hintText: 'Enter your new password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isNewPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.toggleNewPasswordVisibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Confirm new password',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            Obx(
              () => TextField(
                controller: controller.confirmPasswordController,
                obscureText: controller.isConfirmPasswordHidden.value,
                decoration: InputDecoration(
                  hintText: 'Confirm your new password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.setNewPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE4742B),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Reset password",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
