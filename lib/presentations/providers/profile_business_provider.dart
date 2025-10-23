import 'package:flutter/material.dart';

import '../../data/datasources/profile_business_remote_datasource.dart';

import '../../data/models/business_category_model.dart';
import '../../data/models/business_type_model.dart';
import '../../data/models/request/profile_business_request_model.dart';
import '../../data/models/response/business_profile_response_model.dart';

class ProfileBusinessProvider extends ChangeNotifier {
  final ProfileBusinessRemoteDatasource _remoteDatasource;

  // State variables
  bool _isLoadingCategories = false;
  bool _isLoadingTypes = false;
  bool _isSubmitting = false;
  bool _isLoadingInitial = false;
  String? _errorMessage;
  String? _categoriesError;
  String? _typesError;
  List<BusinessCategoryModel> _businessCategories = [];
  List<BusinessTypeModel> _businessTypes = [];
  BusinessProfileResponseModel? _profileData;
  BusinessCategoryModel? _selectedBusinessCategory;
  BusinessTypeModel? _selectedBusinessType;

  ProfileBusinessProvider(this._remoteDatasource);

  // Getters
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingTypes => _isLoadingTypes;
  bool get isSubmitting => _isSubmitting;
  bool get isLoadingInitial => _isLoadingInitial;
  String? get errorMessage => _errorMessage;
  String? get categoriesError => _categoriesError;
  String? get typesError => _typesError;
  List<BusinessCategoryModel> get businessCategories => _businessCategories;
  List<BusinessTypeModel> get businessTypes => _businessTypes;
  BusinessProfileResponseModel? get profileData => _profileData;
  BusinessCategoryModel? get selectedBusinessCategory =>
      _selectedBusinessCategory;
  BusinessTypeModel? get selectedBusinessType => _selectedBusinessType;

  // Get business profile
  Future<bool> getBusinessProfile() async {
    _isLoadingInitial = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _remoteDatasource.getDataBusinessProfile();

    return result.fold(
      (error) {
        _errorMessage = error;
        _isLoadingInitial = false;
        notifyListeners();
        return false;
      },
      (response) {
        _profileData = response;
        _isLoadingInitial = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Get business categories
  Future<bool> getBusinessCategories() async {
    _setLoadingCategories(true);
    _categoriesError = null;

    final result = await _remoteDatasource.getBusinessCategories();

    return result.fold(
      (error) {
        _categoriesError = error;
        _setLoadingCategories(false);
        return false;
      },
      (response) {
        _businessCategories = response.data;
        _setLoadingCategories(false);
        return true;
      },
    );
  }

  // Get business types by category ID
  Future<bool> getBusinessTypesByCategory(int businessCategoryId) async {
    _setLoadingTypes(true);
    _typesError = null;

    final result = await _remoteDatasource.getBusinessTypesByCategory(
      businessCategoryId,
    );

    return result.fold(
      (error) {
        _typesError = error;
        _setLoadingTypes(false);
        return false;
      },
      (response) {
        _businessTypes = response.data;
        _setLoadingTypes(false);
        return true;
      },
    );
  }

  // Complete store profile
  Future<bool> completeStoreProfile(
    ProfileBusinessRequestModel requestModel,
  ) async {
    _setSubmitting(true);
    _errorMessage = null;

    final result = await _remoteDatasource.completeStoreProfile(requestModel);

    return result.fold(
      (error) {
        _errorMessage = error;
        _setSubmitting(false);
        return false;
      },
      (response) {
        _profileData = response;
        _setSubmitting(false);
        return true;
      },
    );
  }

  // Helper methods
  void setSelectedBusinessCategory(BusinessCategoryModel? category) {
    _selectedBusinessCategory = category;
    notifyListeners();
  }

  void setSelectedBusinessType(BusinessTypeModel? type) {
    _selectedBusinessType = type;
    notifyListeners();
  }

  void setLoadingInitial(bool loading) {
    _isLoadingInitial = loading;
    notifyListeners();
  }

  void _setLoadingCategories(bool value) {
    _isLoadingCategories = value;
    notifyListeners();
  }

  void _setLoadingTypes(bool value) {
    _isLoadingTypes = value;
    notifyListeners();
  }

  void _setSubmitting(bool value) {
    _isSubmitting = value;
    notifyListeners();
  }

  void clearBusinessCategories() {
    _businessCategories = [];
    _categoriesError = null;
    notifyListeners();
  }

  void clearBusinessTypes() {
    _businessTypes = [];
    _typesError = null;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setCategoriesError(String error) {
    _categoriesError = error;
    notifyListeners();
  }

  void _setTypesError(String error) {
    _typesError = error;
    notifyListeners();
  }

  // Public methods to clear errors
  void clearError() => _setError('');
  void clearCategoriesError() => _setCategoriesError('');
  void clearTypesError() => _setTypesError('');
  void clearAllErrors() {
    _errorMessage = null;
    _categoriesError = null;
    _typesError = null;
    notifyListeners();
  }
}
