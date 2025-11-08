import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final String email = Get.arguments['email'] ?? '';
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void onClose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }

  void onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String getOTP() {
    return controllers.map((c) => c.text).join();
  }
}
