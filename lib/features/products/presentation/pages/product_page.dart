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

  List<ProductModel> filteredProducts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getProducts();
  }

  Future<void> getProducts() async {
    try {
      products = await datasource.getProducts();

      filteredProducts = products;
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),

                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        filteredProducts = products.where((product) {
                          return product.title.toLowerCase().contains(
                            value.toLowerCase(),
                          );
                        }).toList();
                      });
                    },

                    decoration: InputDecoration(
                      hintText: "Cari produk",

                      prefixIcon: const Icon(Icons.search),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredProducts.length,

                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },

                        child: Card(
                          margin: const EdgeInsets.all(12),

                          child: ListTile(
                            leading: Image.network(product.image, width: 50),

                            title: Text(product.title),

                            subtitle: Text(
                              rupiah.format(product.price * 16000),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
