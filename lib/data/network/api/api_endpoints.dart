class ApiEndpoints {
  //BASE URLS
  static const baseUrl = 'https://dummyjson.com/products';

  //End Urls
  static const productCategories = '/categories';
  static const categoryProducts = '/category/';
  static const searchCategoryProducts = '/search?q=';
  static String products(int limit, skip) => '?limit=$limit&skip=$skip';
}
