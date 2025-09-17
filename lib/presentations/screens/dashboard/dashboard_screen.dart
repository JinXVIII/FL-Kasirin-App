import 'package:flutter/material.dart';

import 'widget/financial_information_card.dart';
import 'widget/menu_item_card.dart';
import 'widget/sales_line_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menus = [
      {"icon": Icons.shopping_cart_outlined, "label": "Kasir", "onTap": () {}},
      {"icon": Icons.inventory_2_outlined, "label": "Produk", "onTap": () {}},
      {
        "icon": Icons.receipt_long_outlined,
        "label": "Riwayat Penjualan",
        "onTap": () {},
      },
      {"icon": Icons.bar_chart_outlined, "label": "Laporan", "onTap": () {}},
      {
        "icon": Icons.people_outline,
        "label": "Karyawan",
        "isPro": true,
        "onTap": () {},
      },
      {
        "icon": Icons.percent_outlined,
        "label": "Pajak",
        "isPro": true,
        "onTap": () {},
      },
      {
        "icon": Icons.menu_book_outlined,
        "label": "Buku Kas",
        "isPro": true,
        "onTap": () {},
      },
      {
        "icon": Icons.play_circle_outline,
        "label": "Video Tutorial",
        "onTap": () {},
      },
      {"icon": Icons.help_outline, "label": "Pusat Bantuan", "onTap": () {}},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // financial information card
            FinancialInformationCard(),
            const SizedBox(height: 20),

            // Menu app
            LayoutBuilder(
              builder: (context, constraint) {
                var spacing = 16.0;
                var rowCount = 4;

                return Wrap(
                  runSpacing: spacing,
                  spacing: spacing,
                  children: List.generate(menus.length, (index) {
                    var item = menus[index];
                    var isProFeature = item["isPro"] ?? false;

                    var size =
                        (constraint.biggest.width -
                            ((rowCount + 1) * spacing)) /
                        rowCount;

                    return MenuItemCard(
                      item: item,
                      size: size,
                      isProFeature: isProFeature,
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 20),

            // Chart sales
            SalesLineChart(),
          ],
        ),
      ),
    );
  }
}
