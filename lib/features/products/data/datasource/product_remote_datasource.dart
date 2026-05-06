import 'package:dio/dio.dart';
import 'package:utd_store_mita/features/products/data/models/product_model.dart';

class ProductRemoteDatasource {
  final Dio dio = Dio();

  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get('https://fakestoreapi.com/products');

    final data = response.data as List;

    return data.map((e) {
      return ProductModel.fromJson(e);
    }).toList();
  }
}
