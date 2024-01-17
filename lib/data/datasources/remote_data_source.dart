import 'package:test_assignment/data/datasources/app_data_source.dart';
import 'package:test_assignment/data/models/category_products_model.dart';
import 'package:test_assignment/data/models/product_category_model.dart';
import 'package:test_assignment/data/network/provider/dio_base_provider.dart';

import '../../app/utils/app_utils.dart';
import '../network/api/api_endpoints.dart';
import '../network/api/api_exceptions.dart';

class RemoteDataSource extends AppDataSource {
  DioBaseProvider? baseProvider = DioBaseProvider();

  @override
  Future<List<String>> fetchCategories() async {
    try {
      var response =
          await baseProvider?.dio.get(ApiEndpoints.productCategories);
      List<dynamic> data = response?.data;
      List<String> mainResponse = List<String>.from(data.map((e) => e));
      return mainResponse;
    } catch (e) {
      AppUtils.showToast(message: ApiExceptions.getDioException(e));
      rethrow;
    }
  }

  @override
  Future<CategoryProductsModel> fetchCategoryProducts(
      String categoryName) async {
    try {
      var response = await baseProvider?.dio
          .get(ApiEndpoints.categoryProducts + categoryName);
      return CategoryProductsModel.fromJson(response?.data);
    } catch (e) {
      AppUtils.showToast(message: ApiExceptions.getDioException(e));
      rethrow;
    }
  }

  @override
  Future<CategoryProductsModel> fetchProducts(int limit, skip) async {
    try {
      var response =
          await baseProvider?.dio.get(ApiEndpoints.products(limit, skip));
      return CategoryProductsModel.fromJson(response?.data);
    } catch (e) {
      AppUtils.showToast(message: ApiExceptions.getDioException(e));
      rethrow;
    }
  }

  @override
  Future<CategoryProductsModel> searchCategoryProducts(
      String categoryName) async {
    try {
      var response = await baseProvider?.dio
          .get(ApiEndpoints.searchCategoryProducts + categoryName);
      return CategoryProductsModel.fromJson(response?.data);
    } catch (e) {
      AppUtils.showToast(message: ApiExceptions.getDioException(e));
      rethrow;
    }
  }
}
