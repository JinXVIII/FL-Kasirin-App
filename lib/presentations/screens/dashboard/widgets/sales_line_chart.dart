import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/themes/text_styles.dart';

import '../../../../data/models/response/sale_statistic_response_model.dart';

import '../../../../presentations/providers/transaction_provider.dart';

class SalesLineChart extends StatefulWidget {
  const SalesLineChart({super.key});

  @override
  State<SalesLineChart> createState() => _SalesLineChartState();
}

class _SalesLineChartState extends State<SalesLineChart> {
  @override
  void initState() {
    super.initState();
    // Load sales count data when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().getSalesCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        return Column(
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Sales Performance', style: AppTextStyles.heading3),
                      const SizedBox(width: 8),
                      Icon(Icons.trending_up, color: AppColors.green, size: 24),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'Jumlah transaksi penjualan per hari',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            AspectRatio(
              aspectRatio: 1.5,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Statistik Penjualan Harian',
                        style: AppTextStyles.heading4,
                      ),
                      const SizedBox(height: 4),

                      const Text(
                        'Jumlah transaksi 7 hari terakhir',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 12),

                      Expanded(
                        child: transactionProvider.isLoadingSalesCount
                            ? Shimmer(
                                duration: const Duration(seconds: 2),
                                interval: const Duration(seconds: 1),
                                color: Colors.grey.shade300,
                                colorOpacity: 0.3,
                                enabled: true,
                                direction: ShimmerDirection.fromLTRB(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Chart title shimmer
                                      Container(
                                        height: 20,
                                        width: 150,
                                        margin: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),

                                      // Chart subtitle shimmer
                                      Container(
                                        height: 14,
                                        width: 120,
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),

                                      // Chart area shimmer
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : transactionProvider.salesCountError != null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: AppColors.red,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 8),

                                    Text(
                                      'Gagal memuat data',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    const SizedBox(height: 8),

                                    ElevatedButton(
                                      onPressed: () {
                                        transactionProvider.getSalesCount();
                                      },
                                      child: const Text('Coba Lagi'),
                                    ),
                                  ],
                                ),
                              )
                            : transactionProvider
                                      .salesCountData
                                      ?.data
                                      .isEmpty ==
                                  true
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bar_chart,
                                      color: AppColors.grey,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 8),

                                    Text(
                                      'Belum ada data penjualan',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ],
                                ),
                              )
                            : LineChart(
                                mainData(
                                  transactionProvider.salesCountData?.data ??
                                      [],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget bottomTitleWidgets(
    double value,
    TitleMeta meta, [
    List<SaleCountModel>? salesData,
  ]) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      fontFamily: 'Poppins',
    );
    String text;

    if (salesData != null && salesData.isNotEmpty) {
      // Get dayCode from sales data
      final index = value.toInt();
      if (index < salesData.length) {
        text = salesData[index].dayCode;
      } else {
        // Fallback to calculated day
        final day = DateTime.now().subtract(Duration(days: 6 - index));
        text = DateFormat.E('id_ID').format(day).substring(0, 1);
      }
    } else {
      // Fallback to calculated day
      final day = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
      text = DateFormat.E('id_ID').format(day).substring(0, 1);
    }

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 10,
      fontFamily: 'Poppins',
    );
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = value.round().toString();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(List<SaleCountModel> salesData) {
    // Process sales data to get counts for the last 7 days
    final Map<DateTime, int> dailySales = {};
    final now = DateTime.now();

    // Initialize last 7 days with 0 sales
    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day - i);
      dailySales[day] = 0;
    }

    // Fill with actual sales data
    for (final sale in salesData) {
      final saleDate = DateTime(sale.date.year, sale.date.month, sale.date.day);
      if (dailySales.containsKey(saleDate)) {
        dailySales[saleDate] = sale.count;
      }
    }

    // Create spots for chart
    final List<FlSpot> spots = [];
    double maxY = 10; // Default max Y value

    dailySales.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key))
      ..forEach((entry) {
        spots.add(FlSpot(spots.length.toDouble(), entry.value.toDouble()));
        maxY = maxY > entry.value ? maxY : entry.value.toDouble();
      });

    // Add some padding to max Y and ensure it's at least 1
    maxY = (maxY * 1.2).ceil().toDouble();
    if (maxY < 1) maxY = 1.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: maxY > 10 ? (maxY / 5).ceilToDouble() : 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) =>
                bottomTitleWidgets(value, meta, salesData),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxY > 10 ? (maxY / 5).ceilToDouble() : 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.orange],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              // Check if this spot is today (last spot in our 7-day range)
              final isToday = index == spots.length - 1;
              return FlDotCirclePainter(
                radius: isToday ? 6 : 4, // Larger dot for today
                color: isToday
                    ? Colors.white
                    : Colors.transparent, // White dot for today
                strokeWidth: isToday ? 2 : 0,
                strokeColor: isToday ? AppColors.primary : Colors.transparent,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withAlpha(30),
                AppColors.orange.withAlpha(30),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
