import 'package:test_assignment/data/models/category_products_model.dart';

import '../datasources/app_data_source.dart';

class AppRepository extends AppDataSource {
  AppDataSource appDataSource;
  AppRepository({required this.appDataSource});

  @override
  Future<List<String>> fetchCategories() {
    return appDataSource.fetchCategories();
  }

  @override
  Future<CategoryProductsModel> fetchCategoryProducts(categoryName) {
    return appDataSource.fetchCategoryProducts(categoryName);
  }

  @override
  Future<CategoryProductsModel> fetchProducts(int limit, skip) {
    return appDataSource.fetchProducts(limit, skip);
  }

  @override
  Future<CategoryProductsModel> searchCategoryProducts(String categoryName) {
    return appDataSource.searchCategoryProducts(categoryName);
  }
}
