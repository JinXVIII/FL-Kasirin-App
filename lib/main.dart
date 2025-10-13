import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'presentations/providers/auth_provider.dart';
import 'presentations/providers/cart_provider.dart';

import 'cores/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            authRemoteDatasource: AuthRemoteDatasource(),
            authLocalDatasource: AuthLocalDatasource(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = Provider.of<AuthProvider>(
            context,
            listen: false,
          );
          final AppRouter appRouter = AppRouter(authProvider: authProvider);

          return MaterialApp.router(
            title: 'Kasirin App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            routerDelegate: appRouter.router.routerDelegate,
            routeInformationParser: appRouter.router.routeInformationParser,
            routeInformationProvider: appRouter.router.routeInformationProvider,
          );
        },
      ),
    );
  }
}
