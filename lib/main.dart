import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'cores/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kasirin App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerDelegate: _appRouter.router.routerDelegate,
      routeInformationParser: _appRouter.router.routeInformationParser,
      routeInformationProvider: _appRouter.router.routeInformationProvider,
    );
  }
}
