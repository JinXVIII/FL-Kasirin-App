import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../cores/themes/text_styles.dart';

import '../../../data/models/product_type_model.dart';

import '../../providers/product_provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/image_picker_widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceBuyController = TextEditingController();
  final _priceSellController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();

  ProductTypeModel? _selectedCategory, _selectedUnit;

  @override
  void initState() {
    super.initState();

    // Load categories and units when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      productProvider.getAllCategories();
      productProvider.getAllUnits();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceBuyController.dispose();
    _priceSellController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih kategori produk'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedUnit == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih unit produk'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // TODO: Implement save product functionality with API
      // For now, just show a success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Produk berhasil ditambahkan dengan kategori ID: ${_selectedCategory!.id} dan unit ID: ${_selectedUnit!.id}',
          ),
          backgroundColor: Colors.green,
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk", style: AppTextStyles.titlePage),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ImagePickerWidget(
                label: "Gambar Produk",
                onChanged: (XFile? value) {
                  if (value != null) {
                    _imageUrlController.text = value.path;
                  }
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
              Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  // Show loading state with disabled dropdown
                  if (provider.isLoadingCategories) {
                    return CustomDropdown<ProductTypeModel>(
                      value: null,
                      items: const [],
                      label: "Kategori",
                      hintText: "Memuat kategori...",
                      enabled: false,
                    );
                  }

                  // Show error state with disabled dropdown
                  if (provider.categoriesError != null) {
                    return CustomDropdown<ProductTypeModel>(
                      value: null,
                      items: const [],
                      label: "Kategori",
                      hintText: "Gagal memuat kategori",
                      enabled: false,
                    );
                  }

                  // Show normal dropdown with data
                  return CustomDropdown<ProductTypeModel>(
                    value: _selectedCategory,
                    items: provider.categories,
                    label: "Kategori",
                    hintText: "Pilih kategori",
                    itemBuilder: (context, item) => Text(item.name),
                    onChanged: (ProductTypeModel? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 16.0),

              // Product unit
              Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  // Show loading state with disabled dropdown
                  if (provider.isLoadingUnits) {
                    return CustomDropdown<ProductTypeModel>(
                      value: null,
                      items: const [],
                      label: "Unit",
                      hintText: "Memuat units...",
                      enabled: false,
                    );
                  }

                  // Show error state with disabled dropdown
                  if (provider.unitsError != null) {
                    return CustomDropdown<ProductTypeModel>(
                      value: null,
                      items: const [],
                      label: "Unit",
                      hintText: "Gagal memuat unit",
                      enabled: false,
                    );
                  }

                  // Show normal dropdown with data
                  return CustomDropdown<ProductTypeModel>(
                    value: _selectedUnit,
                    items: provider.units,
                    label: "Unit",
                    hintText: "Pilih unit",
                    itemBuilder: (context, item) => Text(item.name),
                    onChanged: (ProductTypeModel? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedUnit = newValue;
                        });
                      }
                    },
                  );
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

              // Save button
              CustomButton.filled(
                onPressed: _saveProduct,
                label: "Simpan Produk",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
