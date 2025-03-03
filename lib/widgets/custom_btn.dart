import 'package:flutter/material.dart';

import '../style/app_colors.dart';
import '../style/my_theme_data.dart';

class CustomBtn extends StatelessWidget {
  String titleBtn;
  Function onTap;

  CustomBtn({required this.titleBtn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
            child: Text(
          titleBtn,
          style: MyThemeData.lightTheme.textTheme.titleLarge
              ?.copyWith(fontSize: 20),
        )),
      ),
    );
  }
}
