import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;

  const AppTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
    this.validator,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          filled: true,
          fillColor: const Color(0xFF232323),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}