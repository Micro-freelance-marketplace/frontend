import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFF232323),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
