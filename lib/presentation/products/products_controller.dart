import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_assignment/data/models/category_products_model.dart';
import '../../app/utils/app_utils.dart';
import '../../data/models/product_category_model.dart';
import '../../data/network/provider/service_locator.dart';
import '../../data/repos/app_repository.dart';

class ProductsController extends GetxController {

  RxList<String> categoriesList = <String>['All'].obs;
  RxList<ProductCategoryModel> productCategoriesList =
      <ProductCategoryModel>[].obs;
  RxList<Product> categoryProductsList = <Product>[].obs;
  ScrollController scrollController = ScrollController();
  int currentProductsLength = 20;
  var selectedCategory = 'All'.obs;

  @override
  void onInit() {
    fetchCategories();
    fetchProducts(currentProductsLength, 0);
    scrollController.addListener(_loadMoreData);
    super.onInit();
  }

  fetchCategories() async {
    AppUtils.showLoader();
    await locator<AppRepository>().fetchCategories().then((data) {
      AppUtils.hideLoader();
      if (data.isNotEmpty) {
        categoriesList.assignAll(data);
        categoriesList.insert(0, 'All');
      }
    }).onError((error, stackTrace) {
      AppUtils.hideLoader();
      AppUtils.showToast(message: "Error: $error");
    });
  }

  void _loadMoreData() {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) &&
        (currentProductsLength < 100)) {
      fetchProducts(20, currentProductsLength);
      currentProductsLength = currentProductsLength + 20;
    }
  }

  fetchProducts(int limit, skip) async {
    AppUtils.showLoader();
    await locator<AppRepository>().fetchProducts(20, skip).then((response) {
      AppUtils.hideLoader();
      if (response.products!.isNotEmpty) {
        updateProducts(response.products!);
      }
    }).onError((error, stackTrace) {
      AppUtils.hideLoader();
      AppUtils.showToast(message: "Error: $error");
    });
  }

  fetchCategoryProducts(String categoryName) async {
    AppUtils.showLoader();
    await locator<AppRepository>()
        .fetchCategoryProducts(categoryName)
        .then((response) {
      AppUtils.hideLoader();
      if (response.products!.isNotEmpty) {
        updateProducts(response.products!);
      }
    }).onError((error, stackTrace) {
      AppUtils.hideLoader();
      AppUtils.showToast(message: "Error: $error");
    });
  }

  searchCategoryProduct(String categoryName) async {
    productCategoriesList.clear();
    AppUtils.showLoader();
    await locator<AppRepository>()
        .searchCategoryProducts(categoryName)
        .then((response) {
      AppUtils.hideLoader();
      if (response.products!.isNotEmpty) {
        updateProducts(response.products!);
      }
    }).onError((error, stackTrace) {
      AppUtils.hideLoader();
      AppUtils.showToast(message: "Error: $error");
    });
  }

  void updateProducts(List<Product> products) {
    Map<String, List<Product>> dublicate = {};
    for (var product in products) {
      List<Product>? pro = dublicate[product.category!];
      if (pro == null) {
        dublicate[product.category!] = [product];
      } else {
        dublicate[product.category!] = [...pro, product];
      }
    }
    dublicate.forEach((key, value) {
      productCategoriesList.add(ProductCategoryModel(
        name: key,
        products: value,
      ));
    });
  }
}
