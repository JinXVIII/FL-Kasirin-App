import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/routes/app_router.dart';
import '../../../cores/constants/colors.dart';
import '../../../cores/themes/text_styles.dart';

import 'widgets/financial_information_card.dart';
import 'widgets/menu_item_card.dart';
import 'widgets/sales_line_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menus = [
      {
        "icon": Icons.shopping_cart_outlined,
        "label": "Kasir",
        "onTap": () {
          context.pushNamed(RouteConstants.transaction);
        },
      },
      {
        "icon": Icons.inventory_2_outlined,
        "label": "Produk",
        "onTap": () {
          context.pushNamed(RouteConstants.product);
        },
      },
      {
        "icon": Icons.receipt_long_outlined,
        "label": "Riwayat",
        "onTap": () {
          context.pushNamed(RouteConstants.salesHistory);
        },
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
      {"icon": Icons.play_circle_outline, "label": "Tutorial", "onTap": () {}},
      {"icon": Icons.help_outline, "label": "Bantuan", "onTap": () {}},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard", style: AppTextStyles.titlePage),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.orange),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.orange,
              // size: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: AppColors.body,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // financial information card
              FinancialInformationCard(),
              const SizedBox(height: 14),

              // Menu app
              LayoutBuilder(
                builder: (context, constraint) {
                  var spacing = 8.0;
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
              const SizedBox(height: 14),

              // Chart sales
              SalesLineChart(),
            ],
          ),
        ),
      ),
    );
  }
}
