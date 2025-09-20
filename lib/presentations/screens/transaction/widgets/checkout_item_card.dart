import 'package:flutter/material.dart';

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
    final product = cartItem.product;
    final quantity = cartItem.quantity;
    final subtotal = (product['price'] as int) * quantity;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
                image: product['imageUrl'] != null
                    ? DecorationImage(
                        image: NetworkImage(product['imageUrl']),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product['imageUrl'] == null
                  ? const Icon(Icons.fastfood, size: 30, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12.0),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'Rp ${product['price'].toString()} x $quantity',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'Rp ${subtotal.toString()}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
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
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
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
      ),
    );
  }
}
