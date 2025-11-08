
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomElevatedButton extends StatefulWidget {
  String title;
  String? imagePath;
  String routeName;
  CustomElevatedButton({
    required this.title,
    this.imagePath,
    required this.routeName,
    super.key,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed(widget.routeName);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )
            ),
            SizedBox(
              width: 8,
            ),
            if (widget.imagePath != null)
              Image.asset(
                widget.imagePath!,
                width: 16,
              ),
          ],
        ),
      ),
    );
  }
}