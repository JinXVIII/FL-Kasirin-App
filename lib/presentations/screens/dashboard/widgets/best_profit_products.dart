import 'package:flutter/material.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/themes/text_styles.dart';

class BestProfitProducts extends StatelessWidget {
  const BestProfitProducts({super.key});

  // Sample data for best profit products
  final List<Map<String, dynamic>> _products = const [
    {
      'id': 1,
      'name': 'Kopi Susu',
      'salesCount': 50,
      'profitMargin': 35,
      'imageUrl':
          "https://images.unsplash.com/photo-1544787219-7f47ccb76574?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    },
    {
      'id': 2,
      'name': 'Es Teh Manis',
      'salesCount': 120,
      'profitMargin': 28,
      'imageUrl': null,
    },
    {
      'id': 3,
      'name': 'Ayam Bakar Madu',
      'salesCount': 35,
      'profitMargin': 42,
      'imageUrl': null,
    },
    {
      'id': 4,
      'name': 'Mie Ayam Special',
      'salesCount': 40,
      'profitMargin': 30,
      'imageUrl': null,
    },
    {
      'id': 5,
      'name': 'Jus Alpukat',
      'salesCount': 25,
      'profitMargin': 38,
      'imageUrl': null,
    },
  ];

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
        Container(
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
            itemCount: _products.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) =>
                Divider(height: 0.5, color: AppColors.card, indent: 25),
            itemBuilder: (context, index) {
              final product = _products[index];
              final rank = index + 1;

              return ProductRankItem(
                rank: rank,
                product: product,
                rankColor: _getRankColor(rank),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProductRankItem extends StatelessWidget {
  const ProductRankItem({
    super.key,
    required this.rank,
    required this.product,
    required this.rankColor,
  });

  final int rank;
  final Map<String, dynamic> product;
  final Color rankColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
      child: Row(
        children: [
          // Product image with rank badge - using Container with padding to prevent clipping
          SizedBox(
            width: 85, // Increased width to accommodate badges
            height: 85, // Increased height to accommodate badges
            child: Stack(
              clipBehavior:
                  Clip.none, // Allow stack elements to overflow container
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
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: product['imageUrl'] != null
                            ? NetworkImage(product['imageUrl'])
                            : const AssetImage('assets/images/no-image.png'),
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
                  product['name'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sold ${product['salesCount']}x this month',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          // Profit margin
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${product['profitMargin']}%',
                style: AppTextStyles.priceLarge,
              ),
              Text('Margin', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
