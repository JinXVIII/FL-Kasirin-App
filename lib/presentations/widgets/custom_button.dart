import 'package:flutter/material.dart';

import '../../cores/constants/colors.dart';
import '../../cores/themes/text_styles.dart';

enum ButtonStyle { filled, outlined }

class CustomButton extends StatelessWidget {
  const CustomButton.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyle.filled,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 8,
    this.icon,
    this.disabled = false,
    this.fontSize = 14,
  });

  const CustomButton.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyle.outlined,
    this.color = AppColors.white,
    this.textColor = AppColors.primary,
    this.width = double.infinity,
    this.height = 5,
    this.borderRadius = 8,
    this.icon,
    this.disabled = false,
    this.fontSize = 14,
  });

  final Function() onPressed;
  final String label;
  final ButtonStyle style;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final bool disabled;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: style == ButtonStyle.filled
          ? ElevatedButton(
              onPressed: disabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox.shrink(),
                  if (icon != null) const SizedBox(width: 10.0),
                  Text(
                    label,
                    // style: TextStyle(
                    //   color: textColor,
                    //   fontSize: fontSize,
                    //   fontWeight: FontWeight.w600,
                    // ),
                    style: AppTextStyles.heading4.copyWith(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          : OutlinedButton(
              onPressed: disabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: color,
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox.shrink(),
                  if (icon != null) const SizedBox(width: 10.0),
                  Text(
                    label,
                    // style: TextStyle(
                    //   color: textColor,
                    //   fontSize: fontSize,
                    //   fontWeight: FontWeight.w600,
                    // ),
                    style: AppTextStyles.heading4.copyWith(
                      color: textColor,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
