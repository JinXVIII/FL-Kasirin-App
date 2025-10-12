import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/themes/text_styles.dart';

import '../../../widgets/custom_button.dart';

class ProfileCompletionModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Icon illustration
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.orange.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.store,
                  size: 40,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Lengkapi Profil Pengguna',
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                'Ayo lengkapi profil kamu untuk bisa membuka lebih banyak fitur Kasir!',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: CustomButton.outlined(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: 'Batal',
                      textColor: AppColors.primary,
                      sideColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // OK button
                  Expanded(
                    child: CustomButton.filled(
                      onPressed: () {
                        context.push('/profile');
                      },
                      label: 'Ok',
                      color: AppColors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
