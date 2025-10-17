import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/themes/text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/transaction_provider.dart';

import '../../widgets/custom_button.dart';
import 'widgets/checkout_item_card.dart';
import 'widgets/payment_alert_dialog.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout", style: AppTextStyles.titlePage),
        centerTitle: true,
      ),
      backgroundColor: AppColors.body,
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Keranjang belanja kosong',
                    style: AppTextStyles.heading4,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Order information
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rincian Pesanan',
                        style: AppTextStyles.heading4,
                      ),
                      const SizedBox(height: 8),

                      Expanded(
                        child: ListView.builder(
                          itemCount: cartProvider.cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartProvider.cartItems[index];
                            final ProductModel product = cartItem.product;
                            return CheckoutItemCard(
                              cartItem: cartItem,
                              onIncrease: () {
                                cartProvider.increaseQuantity(product.id);
                              },
                              onDecrease: () {
                                cartProvider.decreaseQuantity(product.id);
                              },
                              onRemove: () {
                                cartProvider.removeFromCart(product.id);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Total and pay button
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.body,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    // Total price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Harga', style: AppTextStyles.caption),
                        Text(
                          'Rp ${cartProvider.totalPrice.toString()}',
                          style: AppTextStyles.heading4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Pay button
                    CustomButton.filled(
                      onPressed: () {
                        _showPaymentDialog(context, cartProvider);
                      },
                      label: "Bayar",
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          return PaymentAlertDialog(
            totalPrice: cartProvider.totalPrice,
            onPaymentSuccess: () {
              cartProvider.clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pembayaran berhasil'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop();
            },
          );
        },
      ),
    );
  }
}
