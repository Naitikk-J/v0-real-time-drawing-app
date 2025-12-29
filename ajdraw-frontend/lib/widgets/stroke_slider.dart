import 'package:flutter/material.dart';

class StrokeSlider extends StatelessWidget {
  final double strokeWidth;
  final Function(double) onStrokeChanged;

  const StrokeSlider({
    Key? key,
    required this.strokeWidth,
    required this.onStrokeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.brush, size: 20),
        ),
        Expanded(
          child: Slider(
            value: strokeWidth,
            min: 1.0,
            max: 20.0,
            divisions: 19,
            label: strokeWidth.toStringAsFixed(1),
            onChanged: onStrokeChanged,
          ),
        ),
      ],
    );
  }
}
