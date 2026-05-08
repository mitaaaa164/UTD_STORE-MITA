import 'package:flutter/material.dart';

import 'package:utd_store_mita/core/storage/favorite_service.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
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
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Products")),

      body: favorites.isEmpty
          ? const Center(child: Text("Belum ada favorite"))
          : ListView.builder(
              itemCount: favorites.length,

              itemBuilder: (context, index) {
                final item = favorites[index];

                return Card(
                  margin: const EdgeInsets.all(12),

                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),

                    title: Text(item),

                    trailing: IconButton(
                      onPressed: () async {
                        await FavoriteService.toggleFavorite(item);

                        if (context.mounted) {
                          Navigator.pop(context, true);
                        }
                      },

                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
