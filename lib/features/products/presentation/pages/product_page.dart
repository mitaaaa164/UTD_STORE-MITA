import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:utd_store_mita/core/storage/favorite_service.dart';

import 'package:utd_store_mita/features/products/data/models/product_model.dart';

import 'package:utd_store_mita/features/products/presentation/cubit/product_cubit.dart';
import 'package:utd_store_mita/features/products/presentation/cubit/product_state.dart';

import 'package:utd_store_mita/features/products/presentation/pages/product_detail_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final rupiah = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  List<ProductModel> allProducts = [];

  List<ProductModel> filteredProducts = [];

  List<String> favorites = [];

  @override
  void initState() {
    super.initState();

    loadFavorites();
  }

  Future<void> loadFavorites() async {
    favorites = await FavoriteService.getFavorites();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit()..getProducts(),

      child: Scaffold(
        appBar: AppBar(
          title: const Text("UTD Store - Mita"),

          actions: [
            IconButton(
              onPressed: () async {
                final result = await context.push('/favorite');
                if (result == true) {
                  loadFavorites();
                }
              },

              icon: const Icon(Icons.favorite),
            ),

            IconButton(
              onPressed: () {
                context.push('/bitcoin');
              },

              icon: const Icon(Icons.currency_bitcoin),
            ),

            IconButton(
              onPressed: () {
                context.push('/battery');
              },

              icon: const Icon(Icons.battery_full),
            ),
          ],
        ),

        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductError) {
              return Center(child: Text(state.message));
            }

            if (state is ProductLoaded) {
              allProducts = state.products;

              if (filteredProducts.isEmpty) {
                filteredProducts = allProducts;
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),

                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          filteredProducts = allProducts.where((product) {
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

                              trailing: IconButton(
                                onPressed: () async {
                                  await FavoriteService.toggleFavorite(
                                    product.title,
                                  );

                                  loadFavorites();
                                },

                                icon: Icon(
                                  favorites.contains(product.title)
                                      ? Icons.favorite
                                      : Icons.favorite_border,

                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
