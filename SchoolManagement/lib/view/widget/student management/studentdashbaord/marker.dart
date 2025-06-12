// Marker Widget
import 'package:flutter/material.dart';

class Marker extends StatelessWidget {
  final Color color;

  const Marker({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
