import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../cores/routes/app_router.dart';
import '../../../../cores/themes/text_styles.dart';

import '../../../../data/models/transaction_model.dart';

class SalesHistoryItemCard extends StatelessWidget {
  final TransactionModel transaction;

  const SalesHistoryItemCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          // Only send ID to detail screen
          context.pushNamed(
            RouteConstants.salesHistoryDetail,
            pathParameters: {'id': transaction.id.toString()},
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
                  Expanded(
                    child: Text(
                      transaction.invoiceNumber,
                      style: AppTextStyles.heading4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Text(
                    DateFormat(
                      'dd MMM yyyy, HH:mm',
                    ).format(transaction.createdAt),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Buyer info (if available)
              if (transaction.buyer != null &&
                  transaction.buyer!.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        transaction.buyer!,
                        style: AppTextStyles.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],

              // Payment method and total amount
              Row(
                children: [
                  const Icon(Icons.payment, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(transaction.paymentMethod, style: AppTextStyles.caption),

                  const Spacer(),

                  Text(
                    'Rp ${NumberFormat('#,###').format(transaction.totalPrice)}',
                    style: AppTextStyles.priceSmall,
                  ),
                ],
              ),

              // Payment details
              if (transaction.paidAmount != transaction.totalPrice) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Dibayar: Rp ${NumberFormat('#,###').format(transaction.paidAmount)}',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.green,
                      ),
                    ),
                    if (transaction.changeAmount > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Kembali: Rp ${NumberFormat('#,###').format(transaction.changeAmount)}',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
