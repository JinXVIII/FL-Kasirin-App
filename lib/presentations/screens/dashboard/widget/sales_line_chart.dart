import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesLineChart extends StatelessWidget {
  const SalesLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xff232d37),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Penjualan Mingguan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Total pendapatan 7 hari terakhir',
                style: TextStyle(color: Color(0xff828996), fontSize: 12),
              ),
              const SizedBox(height: 12),
              Expanded(child: LineChart(mainData())),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff828996),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    final day = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
    text = DateFormat.E('id_ID').format(day).substring(0, 1);

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff828996),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value >= 1000000) {
      text = '${(value / 1000000).toStringAsFixed(1)}Jt';
    } else if (value >= 1000) {
      text = '${(value / 1000).toStringAsFixed(0)}Rb';
    } else {
      return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    final List<double> weeklySales = [
      120000,
      180000,
      150000,
      250000,
      220000,
      300000,
      280000,
    ];

    final List<FlSpot> spots = weeklySales.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 100000,
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
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 100000,
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
      maxY: 400000,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: const LinearGradient(
            colors: [Color(0xff23b6e6), Color(0xff02d39a)],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xff23b6e6).withAlpha(30),
                const Color(0xff02d39a).withAlpha(30),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
