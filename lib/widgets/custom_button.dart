import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomButton extends StatelessWidget {
  final String buttonText;
  final String routeName;
  // Optional parameters that hold arguments
  final dynamic arguments;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.routeName,
    this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed(routeName, arguments: arguments);
        },
        child: Text(buttonText, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}
