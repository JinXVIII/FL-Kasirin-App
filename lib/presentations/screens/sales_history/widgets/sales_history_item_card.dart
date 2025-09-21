import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesHistoryItemCard extends StatelessWidget {
  final Map<String, dynamic> salesData;

  const SalesHistoryItemCard({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    final transactionDate = salesData['transactionDate'] as DateTime;
    final transactionNumber = salesData['transactionNumber'] as String;
    final totalAmount = salesData['totalAmount'] as int;
    final paymentMethod = salesData['paymentMethod'] as String;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with transaction number and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transactionNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(transactionDate),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Payment method
            Row(
              children: [
                const Icon(Icons.payment, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  paymentMethod,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),

                Spacer(),

                Text(
                  'Rp ${NumberFormat('#,###').format(totalAmount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
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
