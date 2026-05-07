import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:utd_store_mita/features/products/data/datasource/product_remote_datasource.dart';

import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final datasource = ProductRemoteDatasource();

  ProductCubit() : super(ProductLoading());

  Future<void> getProducts() async {
    try {
      emit(ProductLoading());

      final products = await datasource.getProducts();

      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
