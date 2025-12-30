import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../models/product.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
    receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
  ));

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get(ApiConstants.products);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Product.fromJson(json)).toList();
      }
      throw Exception('Failed to load products');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.products}/$id');
      
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      }
      throw Exception('Failed to load product');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}