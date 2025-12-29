import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorPicker({
    Key? key,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = [
      Color(0xFFFF6B9D), // Pink
      Color(0xFFC44569), // Dark Pink
      Color(0xFFAA96DA), // Purple
      Color(0xFF6C5B7B), // Dark Purple
      Color(0xFF355C7D), // Blue
      Color(0xFF2A9D8F), // Teal
      Color(0xFFE76F51), // Orange
      Color(0xFFF4A261), // Light Orange
      Color(0xFF2D3436), // Black
      Color(0xFFFFFFFF), // White
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: colors.map((color) {
          final isSelected = color.value == selectedColor.value;
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.black, width: 3)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
