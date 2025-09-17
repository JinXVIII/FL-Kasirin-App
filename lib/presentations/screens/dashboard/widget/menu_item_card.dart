import 'package:flutter/material.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.item,
    required this.size,
    required this.isProFeature,
  });

  final Map<String, dynamic> item;
  final double size;
  final dynamic isProFeature;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => item["onTap"](),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(30),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item["icon"] as IconData,
                    size: size * 0.4, // Ukuran ikon 40% dari ukuran kotak
                    color: Colors.blueGrey[700],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item["label"] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          size * 0.12, // Ukuran teks 12% dari ukuran kotak
                      color: Colors.blueGrey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Tambahkan label "PRO" di pojok kanan atas jika isPro true
            if (isProFeature)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "PRO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
