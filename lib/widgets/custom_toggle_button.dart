import 'package:flutter/material.dart';

class CustomToggleButton extends StatelessWidget {
  final List<String> options;
  final String selected;
  final void Function(String) onSelected;

  const CustomToggleButton({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: options.map((option) {
        final isSelected = selected == option;

        return GestureDetector(
          onTap: () => onSelected(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            margin: EdgeInsets.only( bottom: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 1,
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
