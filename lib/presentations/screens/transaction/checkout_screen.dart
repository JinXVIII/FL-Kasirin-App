import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../cores/routes/app_router.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';
import 'widgets/checkout_item_card.dart';
import 'widgets/payment_alert_dialog.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
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
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Keranjang belanja kosong',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
                        'Informasi Pesanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartProvider.cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartProvider.cartItems[index];
                            return CheckoutItemCard(
                              cartItem: cartItem,
                              onIncrease: () {
                                cartProvider.increaseQuantity(
                                  cartItem.product['id'],
                                );
                              },
                              onDecrease: () {
                                cartProvider.decreaseQuantity(
                                  cartItem.product['id'],
                                );
                              },
                              onRemove: () {
                                cartProvider.removeFromCart(
                                  cartItem.product['id'],
                                );
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
                  color: Colors.grey[100],
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
                        const Text(
                          'Total Harga',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Rp ${cartProvider.totalPrice.toString()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

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
      builder: (context) => PaymentAlertDialog(
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
      ),
    );
  }
}
