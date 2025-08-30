import '../../Model/Product/product.dart';
import '../../Service/service.dart';

class ProductController {
  final ApiService _apiService = ApiService();
  List<Products> products = [];

  Future<List<Products>> fetchproducts() async {
    final fetchedProducts = await _apiService.fetchProducts();
    if (fetchedProducts != null) {
      products = fetchedProducts;
    }
    return products;
  }

  Future<Products?> addProduct(String title, double price, String defaultImageUrl) async {
    final newProduct = await _apiService.createProduct(title, price);
    if (newProduct != null) {
      products.insert(0, newProduct);
    }
    return newProduct;
  }
}