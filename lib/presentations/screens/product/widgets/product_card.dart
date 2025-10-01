import 'package:flutter/material.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/themes/text_styles.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withAlpha(4),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
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
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product['category'] ?? 'Kategori tidak tersedia',
                      style: AppTextStyles.whiteBodySmall.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    product['name'],
                    style: AppTextStyles.heading4.copyWith(fontSize: 14),
                  ),
                  Text(
                    product['price'] != null
                        ? 'Rp ${product['price'].toString()}'
                        : 'Harga tidak tersedia',
                    style: AppTextStyles.priceSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    tooltip: 'Edit Produk',
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Hapus Produk',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
