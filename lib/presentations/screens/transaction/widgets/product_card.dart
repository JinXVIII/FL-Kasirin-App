import 'package:flutter/material.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/constants/variables.dart';
import '../../../../cores/themes/text_styles.dart';

import '../../../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final VoidCallback onAddToCart;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;

  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAddToCart,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: _getImageProvider(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Product details
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.heading4.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),

                Text(
                  'Rp ${product.sellingPrice.toString()}',
                  style: AppTextStyles.priceSmall,
                ),
                const SizedBox(height: 4),

                // Quantity controls or add button
                quantity == 0
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onAddToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Icon(Icons.add, size: 18),
                        ),
                      )
                    : Row(
                        children: [
                          // Decrease button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onDecreaseQuantity,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                              child: const Icon(Icons.remove, size: 18),
                            ),
                          ),

                          // Quantity display
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: Text(
                              quantity.toString(),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),

                          // Increase button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onIncreaseQuantity,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                              child: const Icon(Icons.add, size: 18),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider() {
    final imageUrl = product.thumbnail;

    if (imageUrl != null && imageUrl.toString().isNotEmpty) {
      return NetworkImage('${Variables.baseUrlImage}/$imageUrl');
    } else {
      return const AssetImage('assets/images/no-image.png');
    }
  }
}
