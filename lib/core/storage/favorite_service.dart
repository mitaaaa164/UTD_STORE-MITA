import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList('favorites') ?? [];
  }

  static Future<void> toggleFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(title)) {
      favorites.remove(title);
    } else {
      favorites.add(title);
    }

    await prefs.setStringList('favorites', favorites);
  }
}
