import "dart:convert";
import "package:http/http.dart" as http;

import "../Model/Product/product.dart";

class ApiService
{
  static const String _baseUrl = "https://fakestoreapi.com/products"; //testing url
  // static const String _baseUrl = "https://fakestoreapi.com/products"; // live url

  Future<List<Products>?>fetchProducts() async{
    final response = await http.get(Uri.parse(_baseUrl));

    if(response.statusCode == 200){
      return productsFromJson(response.body);
    }
    return null;
  }

  Future<Products?> createProduct(String title, double price) async{
    final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode(
            {
              "title":title,
              "price":price
            }
        )
    );
    if(response.statusCode == 201 || response.statusCode == 200){
      return Products.fromJson(json.decode((response.body)));
    }
    else{
      return null;
    }
  }
}
