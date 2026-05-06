import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:utd_store_mita/features/products/data/datasource/product_remote_datasource.dart';
import 'package:utd_store_mita/features/products/data/models/product_model.dart';
import 'package:utd_store_mita/features/products/presentation/pages/product_detail_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final datasource = ProductRemoteDatasource();

  final rupiah = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  List<ProductModel> products = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getProducts();
  }

  Future<void> getProducts() async {
    try {
      products = await datasource.getProducts();
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UTD Store - Mita")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,

              itemBuilder: (context, index) {
                final product = products[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: product),
                      ),
                    );
                  },

                  child: Card(
                    margin: const EdgeInsets.all(12),

                    child: ListTile(
                      leading: Image.network(product.image, width: 50),

                      title: Text(product.title),

                      subtitle: Text(rupiah.format(product.price * 16000)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
