import 'package:go_router/go_router.dart';

import '../../presentations/screens/dashboard/dashboard_screen.dart';
import '../../presentations/screens/product/product_screen.dart';
import '../../presentations/screens/product/add_product_screen.dart';
import '../../presentations/screens/product/edit_product_screen.dart';
import '../../presentations/screens/transaction/transaction_screen.dart';
import '../../presentations/screens/transaction/checkout_screen.dart';

class RouteConstants {
  static const String dashboard = 'dashboard';
  static const String dashboardPath = '/dashboard';

  static const String product = 'products';
  static const String productPath = '/products';

  static const String addProduct = 'add-product';
  static const String addProductPath = 'add';

  static const String editProduct = 'edit-product';
  static const String editProductPath = 'edit/:id';

  static const String transaction = 'transaction';
  static const String transactionPath = '/transaction';

  static const String checkout = 'checkout';
  static const String checkoutPath = '/checkout';
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
          GoRoute(
            name: RouteConstants.editProduct,
            path: RouteConstants.editProductPath,
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return EditProductScreen(productId: productId);
            },
          ),
        ],
      ),
      GoRoute(
        name: RouteConstants.transaction,
        path: RouteConstants.transactionPath,
        builder: (context, state) => const TransactionScreen(),
      ),
      GoRoute(
        name: RouteConstants.checkout,
        path: RouteConstants.checkoutPath,
        builder: (context, state) => const CheckoutScreen(),
      ),
    ],
  );
}
