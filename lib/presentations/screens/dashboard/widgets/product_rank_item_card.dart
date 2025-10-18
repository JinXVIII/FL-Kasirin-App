import 'package:flutter/widgets.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/themes/text_styles.dart';

import '../../../../data/models/response/recommendation_response_model.dart';

class ProductRankItemCard extends StatelessWidget {
  const ProductRankItemCard({
    super.key,
    required this.rank,
    required this.recommendation,
    required this.rankColor,
  });

  final int rank;
  final Recommendation recommendation;
  final Color rankColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
      child: Row(
        children: [
          // Product image with rank badge - using Container with padding to prevent clipping
          SizedBox(
            width: 85,
            height: 85,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Product image
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.grey,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/no-image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Rank badge positioned on top left of image
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: rankColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        rank.toString(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.productTypeDetail,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Recommended: ${recommendation.predictedQuantity} units',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          // Recommendation score (margin)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                recommendation.recommendationScore.toString(),
                style: AppTextStyles.priceLarge,
              ),
              Text('Score', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
