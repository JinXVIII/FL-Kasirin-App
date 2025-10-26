import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../cores/constants/variables.dart';
import '../../../cores/themes/text_styles.dart';

import '../../../data/models/request/product_request_model.dart';

import '../../providers/product_provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/image_picker_widget.dart';
import '../../widgets/status_dialog.dart';

class EditProductScreen extends StatefulWidget {
  final int productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceBuyController = TextEditingController();
  final _priceSellController = TextEditingController();
  final _stockController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedUnitId;
  XFile? _selectedImage;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceBuyController.dispose();
    _priceSellController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    // Load categories and units
    await Future.wait([
      productProvider.getAllCategories(),
      productProvider.getAllUnits(),
    ]);

    // Get product by ID
    final success = await productProvider.getProductById(widget.productId);

    if (success && mounted) {
      final product = productProvider.detailProduct;
      if (product != null) {
        setState(() {
          _nameController.text = product.name;
          _priceBuyController.text = product.purchasePrice.toString();
          _priceSellController.text = product.sellingPrice.toString();
          _stockController.text = product.stock.toString();
          _selectedCategoryId = product.productCategory?.id.toString();
          _selectedUnitId = product.productUnit?.id.toString();
          _isInitialized = true;
        });
      } else {
        _showError('Produk tidak ditemukan');
      }
    } else if (mounted) {
      _showError(
        productProvider.detailProductError ?? 'Gagal memuat data produk',
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      StatusDialogs.showFailed(
        context,
        title: 'Error!',
        message: message,
        okButtonText: 'Tutup',
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      StatusDialogs.showSuccess(
        context,
        title: 'Berhasil!',
        message: message,
        okButtonText: 'OK',
        onOkPressed: () {
          if (mounted) {
            context.pop();
          }
        },
      );
    }
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate() &&
        _selectedCategoryId != null &&
        _selectedUnitId != null) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );

      final productRequest = ProductRequestModel(
        name: _nameController.text,
        productCategoryId: int.parse(_selectedCategoryId!),
        productUnitId: int.parse(_selectedUnitId!),
        purchasePrice: int.parse(_priceBuyController.text),
        sellingPrice: int.parse(_priceSellController.text),
        stock: int.parse(_stockController.text),
        thumbnail: _selectedImage,
      );

      final success = await productProvider.editProduct(
        productRequest,
        widget.productId,
      );

      if (success) {
        _showSuccess('Produk berhasil diperbarui');
      } else {
        _showError(
          productProvider.editProductError ?? 'Gagal memperbarui produk',
        );
      }
    } else {
      _showError('Mohon lengkapi semua field yang diperlukan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Produk", style: AppTextStyles.titlePage),
        centerTitle: true,
      ),
      body: _isInitialized
          ? Consumer<ProductProvider>(
              builder: (context, provider, child) {
                final product = provider.detailProduct;
                if (product == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Produk tidak ditemukan',
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: 16),
                        CustomButton.filled(
                          onPressed: () => context.pop(),
                          label: "Kembali",
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product image
                        ImagePickerWidget(
                          label: "Gambar Produk",
                          initialImageUrl:
                              "${Variables.baseUrlImage}/${product.thumbnail}",
                          onChanged: (XFile? value) {
                            setState(() => _selectedImage = value);
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Product name
                        CustomTextField(
                          controller: _nameController,
                          label: "Nama Produk",
                        ),
                        const SizedBox(height: 16.0),

                        // Product category
                        CustomDropdown<String>(
                          value: _selectedCategoryId,
                          items: provider.categories
                              .map((category) => category.id.toString())
                              .toList(),
                          label: "Kategori",
                          hintText: "Pilih kategori",
                          itemBuilder: (context, categoryId) {
                            final category = provider.categories.firstWhere(
                              (c) => c.id.toString() == categoryId,
                              orElse: () => provider.categories.first,
                            );
                            return Text(category.name);
                          },
                          onChanged: (String? newValue) {
                            setState(() => _selectedCategoryId = newValue);
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Product unit
                        CustomDropdown<String>(
                          value: _selectedUnitId,
                          items: provider.units
                              .map((unit) => unit.id.toString())
                              .toList(),
                          label: "Satuan",
                          hintText: "Pilih satuan",
                          itemBuilder: (context, unitId) {
                            final unit = provider.units.firstWhere(
                              (u) => u.id.toString() == unitId,
                              orElse: () => provider.units.first,
                            );
                            return Text(unit.name);
                          },
                          onChanged: (String? newValue) {
                            setState(() => _selectedUnitId = newValue);
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Product price
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _priceBuyController,
                                label: "Harga Beli",
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: CustomTextField(
                                controller: _priceSellController,
                                label: "Harga Jual",
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),

                        // Product stock
                        CustomTextField(
                          controller: _stockController,
                          label: "Stok",
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 24.0),

                        // Update button
                        CustomButton.filled(
                          onPressed: provider.isEditingProduct
                              ? () {}
                              : () => _updateProduct(),
                          label: provider.isEditingProduct
                              ? "Memperbarui..."
                              : "Perbarui Produk",
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Lottie.asset(
                      'assets/animations/loading.json',
                      repeat: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 16),

                  Text("Memuat data produk...", style: AppTextStyles.caption),
                ],
              ),
            ),
    );
  }
}
