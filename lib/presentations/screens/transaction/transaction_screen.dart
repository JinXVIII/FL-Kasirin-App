import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/themes/text_styles.dart';
import '../../../cores/routes/app_router.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'widgets/product_card.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredProducts = [];
  String _searchQuery = '';

  // Sample product data
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'Kopi Hitam',
      'price': 15000,
      'stock': 50,
      'category': 'Minuman',
      'imageUrl':
          'https://images.unsplash.com/photo-1544787219-7f47ccb76574?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    },
    {
      'id': 2,
      'name': 'Teh Manis',
      'price': 10000,
      'stock': 30,
      'category': 'Minuman',
    },
    {
      'id': 3,
      'name': 'Nasi Goreng',
      'price': 25000,
      'stock': 20,
      'category': 'Makanan',
    },
    {
      'id': 4,
      'name': 'Mie Ayam',
      'price': 20000,
      'stock': 15,
      'category': 'Makanan',
      'imageUrl':
          'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    },
    {
      'id': 5,
      'name': 'Es Jeruk',
      'price': 12000,
      'stock': 25,
      'category': 'Minuman',
    },
    {
      'id': 6,
      'name': 'Ayam Goreng',
      'price': 22000,
      'stock': 18,
      'category': 'Makanan',
      'imageUrl':
          'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_products);
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filteredProducts = _products.where((product) {
        return product['name'].toLowerCase().contains(_searchQuery) ||
            product['category'].toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kasir", style: AppTextStyles.titlePage),
        centerTitle: true,
      ),
      backgroundColor: AppColors.body,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomTextField(
              controller: _searchController,
              label: "Cari Produk...",
              showLabel: false,
              suffixIcon: const Icon(Icons.search),
            ),
          ),

          // Products grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return _filteredProducts.isEmpty
                      ? Center(
                          child: Text(
                            'Tidak ada produk ditemukan',
                            style: AppTextStyles.bodyMedium,
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return ProductCard(
                              product: product,
                              quantity: cartProvider.getProductQuantity(
                                product['id'],
                              ),
                              onAddToCart: () {
                                cartProvider.addToCart(product);
                              },
                              onIncreaseQuantity: () {
                                cartProvider.increaseQuantity(product['id']);
                              },
                              onDecreaseQuantity: () {
                                cartProvider.decreaseQuantity(product['id']);
                              },
                            );
                          },
                        );
                },
              ),
            ),
          ),

          // Cart section
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total', style: AppTextStyles.caption),
                        Text(
                          'Rp ${cartProvider.totalPrice.toString()}',
                          style: AppTextStyles.heading4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Checkout button
                    CustomButton.filled(
                      height: 40,
                      width: 150,
                      borderRadius: 6,
                      onPressed: () {
                        if (cartProvider.cartItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Keranjang belanja masih kosong'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        context.pushNamed(RouteConstants.checkout);
                      },
                      label: "Checkout (${cartProvider.totalItems})",
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
