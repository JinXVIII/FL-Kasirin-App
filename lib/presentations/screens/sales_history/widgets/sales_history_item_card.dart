import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../cores/routes/app_router.dart';
import '../../../../cores/themes/text_styles.dart';

class SalesHistoryItemCard extends StatelessWidget {
  final Map<String, dynamic> salesData;

  const SalesHistoryItemCard({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    final transactionDate = salesData['transactionDate'] as DateTime;
    final transactionNumber = salesData['transactionNumber'] as String;
    final totalAmount = salesData['totalAmount'] as int;
    final paymentMethod = salesData['paymentMethod'] as String;
    final id = salesData['id'] as int;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            RouteConstants.salesHistoryDetail,
            pathParameters: {'id': id.toString()},
            extra: salesData,
          );
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with transaction number and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(transactionNumber, style: AppTextStyles.heading4),

                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(transactionDate),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Payment method and total amount
              Row(
                children: [
                  const Icon(Icons.payment, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(paymentMethod, style: AppTextStyles.caption),

                  Spacer(),

                  Text(
                    'Rp ${NumberFormat('#,###').format(totalAmount)}',
                    style: AppTextStyles.priceSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
