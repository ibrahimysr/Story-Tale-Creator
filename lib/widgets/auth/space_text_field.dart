import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/space_theme.dart';

class SpaceTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  const SpaceTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType ?? (isPassword ? TextInputType.visiblePassword : TextInputType.text),
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      textInputAction: textInputAction ?? TextInputAction.next,
      onEditingComplete: onEditingComplete ?? () {
        FocusScope.of(context).nextFocus();
      },
      autocorrect: false,
      enableSuggestions: !isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withValues(alpha:0.7),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white.withValues(alpha:0.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha:0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: SpaceTheme.accentGold,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.red[300]!,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.red[300]!,
          ),
        ),
      ),
    );
  }
} 