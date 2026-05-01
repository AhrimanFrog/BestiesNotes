import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final TextEditingController _controller;
  final String label;
  final Icon icon;
  final String? hint;
  final int? maxLines;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? formatters;

  const InputField(
    this._controller, {
    super.key,
    required this.label,
    required this.icon,
    this.hint,
    this.maxLines,
    this.textInputType,
    this.formatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.softPink),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.softPink),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accentPink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      keyboardType: textInputType,
      maxLines: maxLines ?? 1,
      validator: validator ?? validateNotEmpty,
      inputFormatters: formatters,
    );
  }

  String? validateNotEmpty(String? value) {
    final notValid = value == null || value.trim().isEmpty;
    return notValid ? 'Field cannot be empty' : null;
  }
}
