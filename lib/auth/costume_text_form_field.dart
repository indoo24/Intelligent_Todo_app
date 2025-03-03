import 'package:flutter/material.dart';

import '../style/app_colors.dart';

class CostumeTextFormField extends StatelessWidget {
  TextEditingController controller;
  String label;
  String? Function(String?) validator;
  TextInputType keyboaredType;
  bool obscureText;

  CostumeTextFormField(
      {required this.label,
      required this.controller,
      required this.validator,
      this.keyboaredType = TextInputType.text,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor, width: 2)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor, width: 2)),
            labelText: label),
        controller: controller,
        validator: validator,
        keyboardType: keyboaredType,
        obscureText: obscureText,
      ),
    );
  }
}
