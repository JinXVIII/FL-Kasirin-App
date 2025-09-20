import 'package:flutter/material.dart';

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
  final List<Map<String, dynamic>> _cartItems = [];
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

  int _getProductQuantity(int productId) {
    for (var item in _cartItems) {
      if (item['product']['id'] == productId) {
        return item['quantity'];
      }
    }
    return 0;
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final existingItemIndex = _cartItems.indexWhere(
        (item) => item['product']['id'] == product['id'],
      );

      if (existingItemIndex != -1) {
        // Item already in cart, increase quantity
        _cartItems[existingItemIndex]['quantity'] += 1;
      } else {
        // Add new item to cart
        _cartItems.add({'product': product, 'quantity': 1});
      }
    });
  }

  void _increaseQuantity(int productId) {
    setState(() {
      final existingItemIndex = _cartItems.indexWhere(
        (item) => item['product']['id'] == productId,
      );

      if (existingItemIndex != -1) {
        _cartItems[existingItemIndex]['quantity'] += 1;
      } else {
        // If item doesn't exist in cart, add it
        final product = _products.firstWhere((p) => p['id'] == productId);
        _cartItems.add({'product': product, 'quantity': 1});
      }
    });
  }

  void _decreaseQuantity(int productId) {
    setState(() {
      final existingItemIndex = _cartItems.indexWhere(
        (item) => item['product']['id'] == productId,
      );

      if (existingItemIndex != -1) {
        if (_cartItems[existingItemIndex]['quantity'] > 1) {
          _cartItems[existingItemIndex]['quantity'] -= 1;
        } else {
          // Remove item if quantity would be 0
          _cartItems.removeAt(existingItemIndex);
        }
      }
    });
  }

  int _getTotalPrice() {
    return _cartItems.fold(0, (total, item) {
      return total + (item['product']['price'] * item['quantity'] as int);
    });
  }

  int _getTotalItems() {
    return _cartItems.fold(0, (total, item) {
      return total + (item['quantity'] as int);
    });
  }

  void _processPayment() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang belanja masih kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implement payment processing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Text('Total: Rp ${_getTotalPrice().toString()}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _cartItems.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pembayaran berhasil'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Bayar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kasir",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _filteredProducts = List.from(_products);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextField(
                controller: _searchController,
                label: "Cari Produk...",
                showLabel: false,
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),

          // Products grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _filteredProducts.isEmpty
                  ? const Center(child: Text('Tidak ada produk ditemukan'))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(
                          product: product,
                          quantity: _getProductQuantity(product['id']),
                          onAddToCart: () => _addToCart(product),
                          onIncreaseQuantity: () =>
                              _increaseQuantity(product['id']),
                          onDecreaseQuantity: () =>
                              _decreaseQuantity(product['id']),
                        );
                      },
                    ),
            ),
          ),

          // Cart section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Harga', style: TextStyle(fontSize: 16)),
                    Text(
                      'Rp ${_getTotalPrice().toString()}',
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
                  onPressed: _processPayment,
                  label: "Bayar (${_getTotalItems()})",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
