import 'package:flutter/material.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/constants/variables.dart';
import '../../../../cores/themes/text_styles.dart';

import '../../../../data/models/product_model.dart';

import '../../../providers/cart_provider.dart';

class CheckoutItemCard extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CheckoutItemCard({
    super.key,
    required this.cartItem,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final ProductModel product = cartItem.product;
    final quantity = cartItem.quantity;
    final subtotal = product.sellingPrice * quantity;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: AppColors.white,
      child: Row(
        children: [
          // Product image
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200],
              image: DecorationImage(
                image: _getImageProvider(product),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12.0),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.heading4.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                Text(
                  'Rp ${product.sellingPrice.toString()} x $quantity',
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 4),

                Text(
                  'Rp ${subtotal.toString()}',
                  style: AppTextStyles.priceSmall,
                ),
              ],
            ),
          ),

          // Quantity controls
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Decrease button
                  IconButton(
                    onPressed: onDecrease,
                    icon: const Icon(Icons.remove, size: 18),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                  ),

                  // Quantity display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Text(
                      quantity.toString(),
                      style: AppTextStyles.heading4,
                    ),
                  ),

                  // Increase button
                  IconButton(
                    onPressed: onIncrease,
                    icon: const Icon(Icons.add, size: 18),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // // Remove button
              // IconButton(
              //   onPressed: onRemove,
              //   icon: const Icon(Icons.delete, size: 18, color: Colors.red),
              //   constraints: const BoxConstraints(
              //     minWidth: 32,
              //     minHeight: 32,
              //   ),
              //   padding: EdgeInsets.zero,
              //   tooltip: 'Hapus item',
              // ),
            ],
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(ProductModel product) {
    final imageUrl = product.thumbnail;

    if (imageUrl != null && imageUrl.toString().isNotEmpty) {
      return NetworkImage('${Variables.baseUrlImage}/$imageUrl');
    } else {
      return const AssetImage('assets/images/no-image.png');
    }
  }
}
