import '../../Model/Product/product.dart';
import '../../Service/service.dart';

class productController{
  final ApiService _apiService = ApiService();

  Future<List<Products>?> getProduct() async{
    return await _apiService.fetchProducts();
  }


}