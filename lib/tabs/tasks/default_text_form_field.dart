import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../settings/settings_provider.dart';

class DefaultTextFormField extends StatefulWidget {
  const DefaultTextFormField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.maxLines = 1,
      this.isPassword = false,
      this.validator});

  final String hintText;
  final TextEditingController controller;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool isPassword;

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    return TextFormField(
      controller: widget.controller,
      style: titleMediumStyle!.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  isObscure = !isObscure;
                  setState(() {});
                },
                icon: Icon(
                  isObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 24,
                  color: SettingsProvider().isDark
                      ? AppTheme.white
                      : AppTheme.black,
                ),
              )
            : null,
        hintStyle: titleMediumStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppTheme.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppTheme.primary,
            width: 2,
          ),
        ),
      ),
      maxLines: widget.maxLines,
      validator: widget.validator,
      obscureText: isObscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
