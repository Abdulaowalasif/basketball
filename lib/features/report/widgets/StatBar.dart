import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String title;
  final double value; // from 0 to 1
  const StatBar({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black87,
                fontSize: 16,
              )
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Color(0xFFF6E8E8),
              color: Theme.of(context).colorScheme.primary,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}