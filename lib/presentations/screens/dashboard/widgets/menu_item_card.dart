import 'package:flutter/material.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/themes/text_styles.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.item,
    required this.size,
    required this.isProFeature,
  });

  final Map<String, dynamic> item;
  final double size;
  final dynamic isProFeature;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => item["onTap"](),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(40),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item["icon"] as IconData,
                    size: size * 0.3,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    item["label"] as String,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),

            // Fitur PRO
            if (isProFeature)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "PRO",
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
