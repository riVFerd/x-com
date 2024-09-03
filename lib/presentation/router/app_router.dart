import 'package:go_router/go_router.dart';
import 'package:s_template/presentation/screens/home/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: HomeScreen.path,
  routes: [
    GoRoute(
      path: HomeScreen.path,
      builder: (context, state) => const HomeScreen(),
    )
  ],
);
