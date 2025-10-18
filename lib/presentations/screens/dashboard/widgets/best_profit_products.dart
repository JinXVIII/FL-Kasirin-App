import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/themes/text_styles.dart';

import '../../../providers/recommendation_provider.dart';

import 'product_rank_item_card.dart';

class BestProfitProducts extends StatefulWidget {
  const BestProfitProducts({super.key});

  @override
  State<BestProfitProducts> createState() => _BestProfitProductsState();
}

class _BestProfitProductsState extends State<BestProfitProducts> {
  @override
  void initState() {
    super.initState();
    // Load recommendations when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecommendationProvider>(
        context,
        listen: false,
      ).getRecommendations();
    });
  }

  // Get color for rank 1-5
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold for #1
      case 2:
        return Colors.grey.shade400; // Silver for #2
      case 3:
        return Colors.brown.shade300; // Bronze for #3
      case 4:
        return Colors.blue.shade300; // Blue for #4
      case 5:
        return Colors.green.shade300; // Green for #5
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Top Product Recommendations',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.trending_up, color: AppColors.green, size: 24),
                ],
              ),
              const SizedBox(height: 4),

              Text(
                'Products with high profit potential',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Products list
        Consumer<RecommendationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingRecommendations) {
              return Container(
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            if (provider.recommendationError != null) {
              return Container(
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text('Gagal memuat data', style: AppTextStyles.heading4),
                      const SizedBox(height: 8),
                      Text(
                        provider.recommendationError!,
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          provider.getRecommendations();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final recommendations = provider.topRecommendations;

            if (recommendations.isEmpty) {
              return Container(
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.trending_down, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada data rekomendasi',
                        style: AppTextStyles.heading4,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recommendations.length,
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) =>
                    Divider(height: 0.5, color: AppColors.card, indent: 25),
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index];
                  final rank = index + 1;

                  return ProductRankItemCard(
                    rank: rank,
                    recommendation: recommendation,
                    rankColor: _getRankColor(rank),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
