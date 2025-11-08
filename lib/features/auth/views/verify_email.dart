import 'package:basketball/routes/routes_name.dart';
import 'package:basketball/widgets/custom_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/verify_email_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  VerifyEmailScreen({super.key});

  final VerifyEmailController controller = Get.put(VerifyEmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTitleAppbar(title: 'Verify Email'),
      backgroundColor: const Color(0xFFFEF8F4),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Check your email',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We sent a reset link to ${controller.email}\nPlease enter the 6 digit code.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 55,
                  child: TextField(
                    controller: controller.controllers[index],
                    focusNode: controller.focusNodes[index],
                    onChanged: (value) => controller.onOtpChanged(value, index),
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              'Resend OTP',
              style: TextStyle(color: Colors.deepOrange, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final otp = controller.getOTP();
                  Get.toNamed(
                    RoutesName.resetPass,
                    arguments: {'email': controller.email, 'otp': otp},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE4742B),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Verify code",
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
