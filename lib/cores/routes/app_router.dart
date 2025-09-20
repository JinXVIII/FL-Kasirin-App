import 'package:go_router/go_router.dart';

import '../../presentations/screens/dashboard/dashboard_screen.dart';
import '../../presentations/screens/product/product_screen.dart';
import '../../presentations/screens/product/add_product_screen.dart';

class RouteConstants {
  static const String dashboard = 'dashboard';
  static const String dashboardPath = '/dashboard';

  static const String product = 'products';
  static const String productPath = '/products';

  static const String addProduct = 'add-product';
  static const String addProductPath = '/products/add';
}

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: RouteConstants.dashboardPath,
    routes: [
      GoRoute(
        name: RouteConstants.dashboard,
        path: RouteConstants.dashboardPath,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        name: RouteConstants.product,
        path: RouteConstants.productPath,
        builder: (context, state) => const ProductScreen(),
        routes: [
          GoRoute(
            name: RouteConstants.addProduct,
            path: RouteConstants.addProductPath,
            builder: (context, state) => const AddProductScreen(),
          ),
        ],
      ),
    ],
  );
}
