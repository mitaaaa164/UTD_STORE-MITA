import 'package:go_router/go_router.dart';
import 'package:utd_store_mita/features/products/presentation/pages/product_page.dart';
import 'package:utd_store_mita/features/splash/presentation/pages/splash_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),

    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductPage(),
    ),
  ],
);
