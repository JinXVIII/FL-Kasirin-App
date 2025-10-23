import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/themes/text_styles.dart';

import '../../../data/models/business_category_model.dart';
import '../../../data/models/business_type_model.dart';
import '../../../data/models/request/profile_business_request_model.dart';

import '../../providers/profile_business_provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final provider = context.read<ProfileBusinessProvider>();

    await provider.getBusinessCategories();
    provider.setLoadingInitial(false);
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    final provider = context.read<ProfileBusinessProvider>();

    // Manual validation since CustomTextField doesn't have validator
    if (_businessNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama usaha harus diisi'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (provider.selectedBusinessCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kategori usaha harus dipilih'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (provider.selectedBusinessType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jenis usaha harus dipilih'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alamat usaha harus diisi'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    _saveProfile();
  }

  void _saveProfile() async {
    final provider = context.read<ProfileBusinessProvider>();

    // Create request model
    final requestModel = ProfileBusinessRequestModel(
      storeName: _businessNameController.text,
      businessTypeId: provider.selectedBusinessType!.id,
      address: _addressController.text,
      phoneNumber: _phoneController.text.isNotEmpty
          ? _phoneController.text
          : null,
    );

    final success = await provider.completeStoreProfile(requestModel);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil toko berhasil disimpan!'),
            backgroundColor: AppColors.green,
          ),
        );

        // Navigate back to dashboard
        context.pushReplacement('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Gagal menyimpan profil'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.body,
      appBar: AppBar(
        backgroundColor: AppColors.body,
        elevation: 0,
        title: Text('Lengkapi Profil Toko', style: AppTextStyles.titlePage),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Consumer<ProfileBusinessProvider>(
          builder: (context, provider, child) {
            return provider.isLoadingInitial
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),

                          // Business name field
                          CustomTextField(
                            controller: _businessNameController,
                            label: 'Nama Usaha',
                          ),
                          const SizedBox(height: 20),

                          // Business category dropdown
                          Consumer<ProfileBusinessProvider>(
                            builder: (context, provider, child) {
                              if (provider.isLoadingCategories) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kategori Usaha',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    const SizedBox(height: 6.0),
                                    Shimmer(
                                      duration: const Duration(seconds: 2),
                                      interval: const Duration(seconds: 1),
                                      color: Colors.grey.shade300,
                                      colorOpacity: 0.3,
                                      enabled: true,
                                      direction: ShimmerDirection.fromLTRB(),
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              if (provider.categoriesError != null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kategori Usaha',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.red,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Gagal memuat kategori',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(color: AppColors.red),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      provider.categoriesError!,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return CustomDropdown<BusinessCategoryModel>(
                                value: provider.selectedBusinessCategory,
                                items: provider.businessCategories,
                                label: 'Kategori Usaha',
                                hintText: 'Pilih Kategori Usaha',
                                enabled: !provider.isLoadingCategories,
                                onChanged: (BusinessCategoryModel? newValue) {
                                  // Load business types for selected category
                                  if (newValue != null) {
                                    provider.getBusinessTypesByCategory(
                                      newValue.id,
                                    );
                                  }
                                  provider.setSelectedBusinessCategory(
                                    newValue,
                                  );
                                  provider.setSelectedBusinessType(
                                    null,
                                  ); // Reset business type when category changes
                                },
                                itemBuilder: (context, category) {
                                  return Text(
                                    category.name,
                                    style: AppTextStyles.bodyMedium,
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Business type dropdown
                          Consumer<ProfileBusinessProvider>(
                            builder: (context, provider, child) {
                              // Show loading state when categories are loading
                              if (provider.isLoadingCategories) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jenis Usaha',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    const SizedBox(height: 6.0),
                                    CustomDropdown<BusinessTypeModel>(
                                      value: null,
                                      items: [],
                                      label: 'Jenis Usaha',
                                      hintText:
                                          'Pilih kategori terlebih dahulu',
                                      enabled: false,
                                    ),
                                  ],
                                );
                              }

                              // Show loading state when business types are loading
                              if (provider.isLoadingTypes) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jenis Usaha',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    const SizedBox(height: 6.0),
                                    Shimmer(
                                      duration: const Duration(seconds: 2),
                                      interval: const Duration(seconds: 1),
                                      color: Colors.grey.shade100,
                                      colorOpacity: 0.3,
                                      enabled: true,
                                      direction: ShimmerDirection.fromLTRB(),
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              // Show error state
                              if (provider.typesError != null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jenis Usaha',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.red,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Gagal memuat jenis usaha',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(color: AppColors.red),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      provider.typesError!,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              // Show disabled state when no category is selected
                              if (provider.selectedBusinessCategory == null) {
                                return CustomDropdown<BusinessTypeModel>(
                                  value: null,
                                  items: [],
                                  label: 'Jenis Usaha',
                                  hintText: 'Pilih kategori terlebih dahulu',
                                  enabled: false,
                                );
                              }

                              // Show enabled state with business types
                              return CustomDropdown<BusinessTypeModel>(
                                value: provider.selectedBusinessType,
                                items: provider.businessTypes,
                                label: 'Jenis Usaha',
                                hintText: 'Pilih Jenis Usaha',
                                enabled: !provider.isLoadingTypes,
                                onChanged: (BusinessTypeModel? newValue) {
                                  provider.setSelectedBusinessType(newValue);
                                },
                                itemBuilder: (context, type) {
                                  return Text(
                                    type.name,
                                    style: AppTextStyles.bodyMedium,
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Address field with multiline support
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alamat Usaha',
                                style: AppTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _addressController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: 'Masukkan alamat usaha',
                                  hintStyle: AppTextStyles.caption.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Phone field (optional)
                          CustomTextField(
                            controller: _phoneController,
                            label: 'No Handphone (Opsional)',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 40),

                          // Save button
                          Consumer<ProfileBusinessProvider>(
                            builder: (context, provider, child) {
                              return CustomButton.filled(
                                onPressed: provider.isSubmitting
                                    ? () {}
                                    : _validateAndSave,
                                label: provider.isSubmitting
                                    ? 'Menyimpan...'
                                    : 'Simpan Profil',
                                disabled: provider.isSubmitting,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
