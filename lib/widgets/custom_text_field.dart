import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomTextInput({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(controller: controller, decoration: InputDecoration()),
      ],
    );
  }
}
