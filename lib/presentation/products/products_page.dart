import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_assignment/app/utils/app_strings.dart';
import 'package:test_assignment/data/models/category_products_model.dart';
import 'package:test_assignment/presentation/products/products_controller.dart';

import '../../app/utils/debouncer.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  var controller = Get.put(ProductsController());
  final Debouncer _debouncer = Debouncer(milliseconds: 500);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  const Spacer(),
                  const Text(
                    AppStrings.products,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(5),
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButton(
                        isDense: true,
                        underline: Container(),
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w800),
                        isExpanded: true,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        value: controller.selectedCategory.value,
                        onChanged: (String? newValue) {
                          controller.selectedCategory(newValue!);
                          controller.productCategoriesList.clear();
                          if (newValue == AppStrings.all) {
                            controller.fetchProducts(
                                controller.currentProductsLength, 0);
                          } else {
                            controller.fetchCategoryProducts(newValue);
                          }
                        },
                        items: controller.categoriesList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                height: 40,
                child: TextField(
                    onChanged: (value) {
                      _debouncer.run(() {
                        controller.selectedCategory(AppStrings.all);
                        if(value.isNotEmpty){
                          controller.searchCategoryProduct(value);
                        }else{
                          controller.productCategoriesList.clear();
                          controller.fetchProducts(
                              controller.currentProductsLength, 0);
                        }
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        hintText: AppStrings.searchProducts,
                        hintStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.grey),
                        ))),
              ),
              const SizedBox(height: 30),
              Obx(() => Expanded(
                    child: ListView.builder(
                        controller: controller.scrollController,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: controller.productCategoriesList.length,
                        itemBuilder: (context, mainIndex) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  controller
                                      .productCategoriesList[mainIndex].name,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Column(
                                  children: List.generate(
                                      controller
                                                  .productCategoriesList[
                                                      mainIndex]
                                                  .products !=
                                              null
                                          ? controller
                                              .productCategoriesList[mainIndex]
                                              .products!
                                              .length
                                          : 0,
                                      (index) => _productWidget(
                                          index,
                                          controller
                                                      .productCategoriesList[
                                                          mainIndex]
                                                      .products !=
                                                  null
                                              ? controller
                                                  .productCategoriesList[
                                                      mainIndex]
                                                  .products!
                                              : [])))
                            ],
                          );
                        }),
                  )),
            ],
          ),
        ),
      ),
    );
  }



  Widget _productWidget(int index, List<Product> products) {
    return GestureDetector(
      onTap: (){
        _showInfoDialog(context,index,products);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Center(
                child: CachedNetworkImage(
                  height: 40,
                  width: 50,
                  fit: BoxFit.fill,
                  imageUrl: products[index].thumbnail.toString(),
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.black)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width / 1.5,
                  child: Text(
                    products[index].title.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: Get.width / 1.5,
                  child: Text(
                    products[index].description.toString(),
                    maxLines: 3,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showInfoDialog(BuildContext context, int index, List<Product> products) async {
    String title=products[index].title.toString();
    String description=products[index].description.toString();
    List<String> imagesList=products[index].images ?? [];
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppStrings.productInfo),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(title),
                const SizedBox(height: 10),
                Text(description),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  width: Get.width,
                  child:ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildImage(imagesList[index]);
                    },
                  )
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(AppStrings.close),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imagePath,
          width: 200,
          height: 80,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

}
