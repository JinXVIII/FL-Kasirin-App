import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../cores/constants/variables.dart';
import '../models/response/business_category_response_model.dart';
import '../models/response/business_profile_response_model.dart';
import '../models/response/business_type_response_model.dart';
import '../models/request/profile_business_request_model.dart';
import 'auth_local_datasource.dart';

class ProfileBusinessRemoteDatasource {
  // Get business categories
  Future<Either<String, BusinessProfileResponseModel>>
  getDataBusinessProfile() async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/profile'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Business Profile Response status: ${response.statusCode}');
    debugPrint('Business Profile Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final businessProfileResponse = BusinessProfileResponseModel.fromJson(
          response.body,
        );
        debugPrint('Business profile successfully: $businessProfileResponse');
        return Right(businessProfileResponse);
      } catch (e) {
        debugPrint('Error parsing business categories response: $e');
        return Left('Error parsing response: $e');
      }
    } else {
      debugPrint('Error retrieving business categories: ${response.body}');
      return Left(response.body);
    }
  }

  // Get business categories
  Future<Either<String, BusinessCategoryResponseModel>>
  getBusinessCategories() async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/business-categories'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Business Categories Response status: ${response.statusCode}');
    debugPrint('Business Categories Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final businessCategoriesResponse =
            BusinessCategoryResponseModel.fromJson(response.body);
        debugPrint('Business categories retrieved successfully');
        debugPrint(
          'Total categories: ${businessCategoriesResponse.data.length}',
        );
        return Right(businessCategoriesResponse);
      } catch (e) {
        debugPrint('Error parsing business categories response: $e');
        return Left('Error parsing response: $e');
      }
    } else {
      debugPrint('Error retrieving business categories: ${response.body}');
      return Left(response.body);
    }
  }

  // Get business types by category ID
  Future<Either<String, BusinessTypeResponseModel>> getBusinessTypesByCategory(
    int businessCategoryId,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.get(
      Uri.parse(
        '${Variables.baseUrl}/business-types?category_id=$businessCategoryId',
      ),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Business Types Response status: ${response.statusCode}');
    debugPrint('Business Types Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final businessTypesResponse = BusinessTypeResponseModel.fromJson(
          response.body,
        );
        debugPrint('Business types retrieved successfully');
        debugPrint('Total types: ${businessTypesResponse.data.length}');
        return Right(businessTypesResponse);
      } catch (e) {
        debugPrint('Error parsing business types response: $e');
        return Left('Error parsing response: $e');
      }
    } else {
      debugPrint('Error retrieving business types: ${response.body}');
      return Left(response.body);
    }
  }

  // Complete store profile
  Future<Either<String, BusinessProfileResponseModel>> completeStoreProfile(
    ProfileBusinessRequestModel requestModel,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.put(
      Uri.parse('${Variables.baseUrl}/profile'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: requestModel.toJson(),
    );

    debugPrint('Complete Profile Response status: ${response.statusCode}');
    debugPrint('Complete Profile Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final responseData = BusinessProfileResponseModel.fromJson(
          response.body,
        );
        debugPrint('Store profile completed successfully');
        debugPrint('Response: $responseData');
        return Right(responseData);
      } catch (e) {
        debugPrint('Error parsing complete profile response: $e');
        return Left('Error parsing response: $e');
      }
    } else {
      debugPrint('Error completing store profile: ${response.body}');
      return Left(response.body);
    }
  }
}
