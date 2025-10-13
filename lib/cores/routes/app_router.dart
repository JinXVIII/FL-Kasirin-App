import 'package:go_router/go_router.dart';

import '../../presentations/providers/auth_provider.dart';

import '../../presentations/screens/splash/splash_screen.dart';
import '../../presentations/screens/auth/login_screen.dart';
import '../../presentations/screens/auth/register_screen.dart';
import '../../presentations/screens/profile/profile_screen.dart';
import '../../presentations/screens/dashboard/dashboard_screen.dart';
import '../../presentations/screens/product/product_screen.dart';
import '../../presentations/screens/product/add_product_screen.dart';
import '../../presentations/screens/product/edit_product_screen.dart';
import '../../presentations/screens/transaction/transaction_screen.dart';
import '../../presentations/screens/transaction/checkout_screen.dart';
import '../../presentations/screens/sales_history/sales_history_screen.dart';
import '../../presentations/screens/sales_history/sales_history_detail_screen.dart';

class RouteConstants {
  static const String splash = 'splash';
  static const String splashPath = '/';

  static const String login = 'login';
  static const String loginPath = '/login';

  static const String register = 'register';
  static const String registerPath = '/register';

  static const String profile = 'profile';
  static const String profilePath = '/profile';

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

  static const String salesHistory = 'sales-history';
  static const String salesHistoryPath = '/sales-history';

  static const String salesHistoryDetail = 'sales-history-detail';
  static const String salesHistoryDetailPath = '/sales-history/:id';
}

class AppRouter {
  final GoRouter router;

  AppRouter({required AuthProvider authProvider})
    : router = GoRouter(
        initialLocation: RouteConstants.splashPath,
        redirect: (context, state) {
          final isAuthenticated = authProvider.isAuthenticated;
          final isAuthRoute =
              state.uri.path.startsWith('/login') ||
              state.uri.path.startsWith('/register');
          final isSplashRoute = state.uri.path == RouteConstants.splashPath;

          if (!isAuthenticated && !isAuthRoute && !isSplashRoute) {
            return RouteConstants.loginPath;
          }

          if (isAuthenticated && isAuthRoute && !isSplashRoute) {
            return RouteConstants.dashboardPath;
          }

          return null;
        },
        routes: [
          GoRoute(
            name: RouteConstants.splash,
            path: RouteConstants.splashPath,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            name: RouteConstants.login,
            path: RouteConstants.loginPath,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            name: RouteConstants.register,
            path: RouteConstants.registerPath,
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            name: RouteConstants.profile,
            path: RouteConstants.profilePath,
            builder: (context, state) => const ProfileScreen(),
          ),
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
          GoRoute(
            name: RouteConstants.salesHistory,
            path: RouteConstants.salesHistoryPath,
            builder: (context, state) => const SalesHistoryScreen(),
          ),
          GoRoute(
            name: RouteConstants.salesHistoryDetail,
            path: RouteConstants.salesHistoryDetailPath,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SalesHistoryDetailScreen(
                salesData: {
                  'id': int.parse(id),
                  'transactionNumber': 'TRX-20230921-001',
                  'transactionDate': DateTime.now(),
                  'totalAmount': 42000,
                  'paymentMethod': 'E-Wallet',
                  'items': [
                    {
                      'productName': 'Nasi Goreng',
                      'quantity': 1,
                      'price': 25000,
                    },
                    {
                      'productName': 'Kopi Hitam',
                      'quantity': 1,
                      'price': 15000,
                    },
                  ],
                },
              );
            },
          ),
        ],
      );
}
