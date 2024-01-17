// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'category_products_model.dart';

class ProductCategoryModel {
  final String name;
  final List<Product>? products;

  ProductCategoryModel({required this.name, this.products});

  factory ProductCategoryModel.fromJson(String value) {
    return ProductCategoryModel(
      name: value,
    );
  }

  ProductCategoryModel copyWith({
    String? name,
    List<Product>? products,
  }) {
    return ProductCategoryModel(
      name: name ?? this.name,
      products: products ?? this.products,
    );
  }
}
