import 'package:image_picker/image_picker.dart';

class ProductRequestModel {
  final String name;
  final int productCategoryId;
  final int productUnitId;
  final int purchasePrice;
  final int sellingPrice;
  final int stock;
  final XFile? thumbnail;

  ProductRequestModel({
    required this.name,
    required this.productCategoryId,
    required this.productUnitId,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
    this.thumbnail,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'product_category_id': productCategoryId.toString(),
      'product_unit_id': productUnitId.toString(),
      'purchase_price': purchasePrice.toString(),
      'selling_price': sellingPrice.toString(),
      'stock': stock.toString(),
    };
  }
}
