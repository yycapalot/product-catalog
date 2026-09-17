import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com/products';

  // Product pagination response
  Future<ProductResponse> getProducts({int limit = 20, int skip = 0}) async {
    final url = Uri.parse('$_baseUrl?limit=$limit&skip=$skip');
    final response = await http.get(url);

    if (response.statusCode == 200){
      final data = json.decode(response.body);
      return ProductResponse.fromJson(data);
    }
    else{
      throw Exception('Failed to load products, Status Code: ${response.statusCode}');
    }
  }

  // Product details
  Future<Product> getProductDetails(int id) async{
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200){
      final data = json.decode(response.body);
      return Product.fromJson(data);
    }
    else{
      throw Exception('Failed to load products details, Status Code: ${response.statusCode}');
    }
  }

  // Product query
  Future<ProductResponse> searchProducts(String query) async {
    final url = Uri.parse('$_baseUrl/search?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProductResponse.fromJson(data);
    } else {
      throw Exception('Failed to search products.');
    }
  }
}