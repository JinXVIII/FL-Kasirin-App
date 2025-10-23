import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/themes/text_styles.dart';

import '../../../data/models/business_category_model.dart';
import '../../../data/models/business_type_model.dart';
import '../../../data/models/request/profile_business_request_model.dart';

import '../../providers/profile_business_provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPasswordFields = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final provider = context.read<ProfileBusinessProvider>();

    // Load business categories and profile data
    await Future.wait([
      provider.getBusinessCategories(),
      provider.getBusinessProfile(),
    ]);

    // Populate form if profile data exists
    if (mounted && provider.profileData?.data != null) {
      final profileData = provider.profileData!.data.businessProfile;
      final userData = provider.profileData!.data;

      _businessNameController.text = profileData.storeName;
      _addressController.text = profileData.address;
      _phoneController.text = profileData.phoneNumber;
      _nameController.text = userData.name;

      // Find and set the business category from the provider's list
      if (profileData.businessType.businessCategory != null) {
        final businessCategory = profileData.businessType.businessCategory!;
        provider.setSelectedBusinessCategory(
          provider.businessCategories.firstWhere(
            (category) => category.id == businessCategory.id,
            orElse: () => businessCategory,
          ),
        );

        // Load business types for this category
        await provider.getBusinessTypesByCategory(businessCategory.id);

        // Set selected business type after business types are loaded
        final businessType = profileData.businessType;
        provider.setSelectedBusinessType(
          provider.businessTypes.firstWhere(
            (type) => type.id == businessType.id,
            orElse: () => businessType,
          ),
        );
      }
    }

    provider.setLoadingInitial(false);
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    final provider = context.read<ProfileBusinessProvider>();

    // Manual validation since CustomTextField doesn't have validator
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama harus diisi'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

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

    // Validate password fields if they are shown
    if (_showPasswordFields) {
      if (_newPasswordController.text.isNotEmpty) {
        if (_newPasswordController.text.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password baru minimal 6 karakter'),
              backgroundColor: AppColors.red,
            ),
          );
          return;
        }

        if (_newPasswordController.text != _confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Konfirmasi password tidak cocok'),
              backgroundColor: AppColors.red,
            ),
          );
          return;
        }
      }
    }

    _saveProfile();
  }

  void _saveProfile() async {
    final provider = context.read<ProfileBusinessProvider>();

    // First update business profile
    final requestModel = ProfileBusinessRequestModel(
      storeName: _businessNameController.text,
      businessTypeId: provider.selectedBusinessType!.id,
      address: _addressController.text,
      phoneNumber: _phoneController.text.isNotEmpty
          ? _phoneController.text
          : null,
    );

    final businessSuccess = await provider.completeStoreProfile(requestModel);

    if (mounted) {
      if (businessSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil toko berhasil diperbarui!'),
            backgroundColor: AppColors.green,
          ),
        );

        // Navigate back to dashboard
        context.pushReplacement('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Gagal memperbarui profil'),
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
        title: Text('Edit Profil', style: AppTextStyles.titlePage),
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

                          // User name field
                          CustomTextField(
                            controller: _nameController,
                            label: 'Nama Lengkap',
                          ),
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
                                return CustomDropdown<BusinessCategoryModel>(
                                  value: null,
                                  items: const [],
                                  label: "Kategori Usaha",
                                  hintText: "Memuat kategori usaha...",
                                  enabled: false,
                                );
                              }

                              if (provider.categoriesError != null) {
                                return CustomDropdown<BusinessCategoryModel>(
                                  value: null,
                                  items: const [],
                                  label: "Kategori usaha",
                                  hintText: "Gagal memuat kategori usaha",
                                  enabled: false,
                                );
                              }

                              return CustomDropdown<BusinessCategoryModel>(
                                value: provider.selectedBusinessCategory,
                                items: provider.businessCategories,
                                label: 'Kategori Usaha',
                                hintText: 'Pilih Kategori Usaha',
                                enabled: !provider.isLoadingCategories,
                                onChanged: (BusinessCategoryModel? newValue) {
                                  if (newValue != null) {
                                    provider.getBusinessTypesByCategory(
                                      newValue.id,
                                    );
                                  }
                                  provider.setSelectedBusinessCategory(
                                    newValue,
                                  );
                                  provider.setSelectedBusinessType(null);
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
                                if (provider.isLoadingCategories) {
                                  return CustomDropdown<BusinessTypeModel>(
                                    value: null,
                                    items: [],
                                    label: 'Jenis Usaha',
                                    hintText: 'Pilih kategori terlebih dahulu',
                                    enabled: false,
                                  );
                                }
                              }

                              // Show loading state when business types are loading
                              if (provider.isLoadingTypes) {
                                return CustomDropdown<BusinessTypeModel>(
                                  value: null,
                                  items: const [],
                                  label: "Jenis Usaha",
                                  hintText: "Memuat jenis usaha...",
                                  enabled: false,
                                );
                              }

                              // Show error state
                              if (provider.typesError != null) {
                                return CustomDropdown<BusinessTypeModel>(
                                  value: null,
                                  items: const [],
                                  label: "Jenis Usaha",
                                  hintText: "Gagal memuat jenis usaha",
                                  enabled: false,
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
                          const SizedBox(height: 30),

                          // Password section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ubah Password',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _showPasswordFields =
                                              !_showPasswordFields;
                                        });
                                      },
                                      child: Text(
                                        _showPasswordFields ? 'Batal' : 'Ubah',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.orange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_showPasswordFields) ...[
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    controller: _newPasswordController,
                                    label: 'Password Baru (Minimal 6 karakter)',
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    controller: _confirmPasswordController,
                                    label: 'Konfirmasi Password Baru',
                                    obscureText: true,
                                  ),
                                ],
                              ],
                            ),
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
                                    : 'Simpan Perubahan',
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
