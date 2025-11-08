import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final String content;

  const Section({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium ),
          const SizedBox(height: 8),
          Text(
              content,style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.black87,
            fontSize: 16,
            height: 1.2,
          )
          ),
        ],
      ),
    );
  }
}