import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/select_theme.dart';
import '../style/app_colors.dart';

class CustomTextFiled extends StatelessWidget {
  String hintText;
  String? Function(String?)? validator;
  TextEditingController? controller;
  bool obscureText = false;
  TextInputType keyboardType = TextInputType.text;
  Widget? suffixIcon;
  var hintStyle;

  CustomTextFiled({
    required this.hintText,
    required this.validator,
    required this.controller,
    required this.obscureText,
    this.keyboardType = TextInputType.text,
    required this.suffixIcon,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<SelectTheme>(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: hintStyle,
          fillColor: themeProvider.isDarkMode()
              ? AppColors.cardDarkColor
              : AppColors.whiteColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 2,
              color: AppColors.blackColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 2,
              color: AppColors.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 2,
              color: AppColors.blackColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 2,
              color: AppColors.redColor,
            ),
          ),
          filled: true),
    );
  }
}
