import 'dart:convert';

class RecommendationModel {
  final int productId;
  final String productTypeDetail;
  final int predictedQuantity;
  final double recommendationScore;
  final int dataPoints;
  final String thumbnail;

  RecommendationModel({
    required this.productId,
    required this.productTypeDetail,
    required this.predictedQuantity,
    required this.recommendationScore,
    required this.dataPoints,
    required this.thumbnail,
  });

  factory RecommendationModel.fromJson(String str) =>
      RecommendationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RecommendationModel.fromMap(Map<String, dynamic> json) =>
      RecommendationModel(
        productId: json["product_id"],
        productTypeDetail: json["product_type_detail"],
        predictedQuantity: json["predicted_quantity"],
        recommendationScore: json["recommendation_score"]?.toDouble(),
        dataPoints: json["data_points"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toMap() => {
    "product_id": productId,
    "product_type_detail": productTypeDetail,
    "predicted_quantity": predictedQuantity,
    "recommendation_score": recommendationScore,
    "data_points": dataPoints,
    "thumbnail": thumbnail,
  };
}
