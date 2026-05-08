import 'package:go_router/go_router.dart';

import 'package:utd_store_mita/features/splash/presentation/pages/splash_page.dart';
import 'package:utd_store_mita/features/products/presentation/pages/product_page.dart';
import 'package:utd_store_mita/features/bitcoin/presentation/pages/bitcoin_page.dart';
import 'package:utd_store_mita/features/products/presentation/pages/favorite_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),

    GoRoute(path: '/product', builder: (context, state) => const ProductPage()),

    GoRoute(path: '/bitcoin', builder: (context, state) => const BitcoinPage()),

    GoRoute(
      path: '/favorite',
      builder: (context, state) => const FavoritePage(),
    ),
  ],
);
