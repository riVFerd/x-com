import 'package:flutter/material.dart';
import 'package:s_template/presentation/router/app_router.dart';
import 'package:s_template/presentation/themes/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Starter Template',
      theme: appTheme,
      routerConfig: appRouter,
    );
  }
}
