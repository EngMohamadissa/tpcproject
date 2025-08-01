import 'package:dio/dio.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/core/util/error/error_handling.dart';
import 'package:tcp/feutaure/Product/data/get_all_product_model.dart';

class ProductListRepo {
  final ApiService _apiService;

  ProductListRepo(this._apiService);

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _apiService
          .get('products'); // Assuming 'products' is your endpoint
      if (response.statusCode == 200) {
        final List<dynamic> productJsonList = response.data['data'];
        return productJsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future deleteProduct(int productId) async {
    try {
      final response = await _apiService.delete('products/$productId');
      if (response.statusCode == 200) {
        return response.data['message']
            .toString(); // print('Product deleted successfully: $productId');
      } else {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
