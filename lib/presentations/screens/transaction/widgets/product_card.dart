import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[200],
                image: product['imageUrl'] != null
                    ? DecorationImage(
                        image: NetworkImage(product['imageUrl']),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product['imageUrl'] == null
                  ? const Icon(Icons.fastfood, size: 48, color: Colors.grey)
                  : null,
            ),
          ),

          // Product details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                Text(
                  'Rp ${product['price'].toString()}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                // Quantity controls or add button
                quantity == 0
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onAddToCart,
                          style: ElevatedButton.styleFrom(
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    topLeft: Radius.circular(8),
                                  ),
                                ),
                              ),
                              child: const Icon(Icons.remove, size: 18),
                            ),
                          ),
                          // Quantity display
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border(
                                top: BorderSide(color: Colors.grey[300]!),
                                bottom: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            child: Text(
                              quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Increase button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onIncreaseQuantity,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(8),
                                    topRight: Radius.circular(8),
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
}
