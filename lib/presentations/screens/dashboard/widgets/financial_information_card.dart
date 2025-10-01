import 'package:fe_kasirin_app/cores/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../cores/themes/text_styles.dart';

class FinancialInformationCard extends StatelessWidget {
  const FinancialInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Warung Madura United", style: AppTextStyles.whiteHeading3),
          const SizedBox(height: 4),

          Divider(thickness: 0.5, color: Colors.white),
          const SizedBox(height: 4),

          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Omzet Hari Ini",
                        style: AppTextStyles.whiteBodySmall,
                      ),
                      Text("Rp 100.000", style: AppTextStyles.whiteHeading4),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Omzet Bulan Ini",
                        style: AppTextStyles.whiteBodySmall,
                      ),
                      Text("Rp 1.000.000", style: AppTextStyles.whiteHeading4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Produk Terjual Hari Ini",
                        style: AppTextStyles.whiteBodySmall,
                      ),
                      Text("10", style: AppTextStyles.whiteHeading4),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Produk Terjual Bulan Ini",
                        style: AppTextStyles.whiteBodySmall,
                      ),
                      Text("100", style: AppTextStyles.whiteHeading4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
