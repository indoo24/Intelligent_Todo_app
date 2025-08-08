import 'package:flutter/material.dart';

import '../../app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  const DefaultElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 52)),
      child: Text(
        label,
        style: titleMediumStyle?.copyWith(
            fontWeight: FontWeight.w400, color: AppTheme.white),
      ),
    );
  }
}
