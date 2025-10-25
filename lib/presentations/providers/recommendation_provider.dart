import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import '../../data/datasources/recommendation_remote_datasource.dart';

import '../../data/models/recommendation_model.dart';
import '../../data/models/response/recommendation_response_model.dart';

class RecommendationProvider extends ChangeNotifier {
  final RecommendationRemoteDatasource _remoteDatasource;

  RecommendationProvider(this._remoteDatasource);

  // Recommendation states
  bool _isLoadingRecommendations = false;
  String? _recommendationError;
  RecommendationResponseModel? _recommendationData;

  // Getters
  bool get isLoadingRecommendations => _isLoadingRecommendations;
  String? get recommendationError => _recommendationError;
  RecommendationResponseModel? get recommendationData => _recommendationData;

  // Get top recommendations (sorted by score)
  List<RecommendationModel> get topRecommendations {
    if (_recommendationData?.data.recommendations == null) {
      return [];
    }

    // Sort by recommendation score in descending order and take top 5
    final recommendations = List<RecommendationModel>.from(
      _recommendationData!.data.recommendations,
    );

    recommendations.sort(
      (a, b) => b.recommendationScore.compareTo(a.recommendationScore),
    );

    return recommendations.take(5).toList();
  }

  // Get recommendation method
  Future<bool> getRecommendations() async {
    _setLoadingRecommendations(true);
    _recommendationError = null;

    final Either<String, RecommendationResponseModel> result =
        await _remoteDatasource.getRecommendationProdductsML();

    return result.fold(
      (error) {
        _recommendationError = error;
        _setLoadingRecommendations(false);
        return false;
      },
      (response) {
        _recommendationData = response;
        _setLoadingRecommendations(false);
        return true;
      },
    );
  }

  // Set loading state
  void _setLoadingRecommendations(bool value) {
    _isLoadingRecommendations = value;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _recommendationError = null;
    notifyListeners();
  }

  // Clear recommendation data
  void clearRecommendations() {
    _recommendationData = null;
    _recommendationError = null;
    notifyListeners();
  }
}
