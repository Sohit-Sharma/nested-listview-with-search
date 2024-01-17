import 'package:test_assignment/data/models/category_products_model.dart';

abstract class AppDataSource {
  Future<List<String>> fetchCategories();
  Future<CategoryProductsModel> fetchCategoryProducts(String categoryName);
  Future<CategoryProductsModel> searchCategoryProducts(String categoryName);
  Future<CategoryProductsModel> fetchProducts(int limit, skip);
}
