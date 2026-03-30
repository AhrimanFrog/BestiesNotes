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
        border: OutlineInputBorder(),
        prefixIcon: icon,
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
