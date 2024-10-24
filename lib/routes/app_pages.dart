import 'package:go_router/go_router.dart';

import '../views/home/home_screen.dart';

class AppPages {
  static GoRouter routerConfig = GoRouter(
    initialLocation: "/",
    // navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: "/",
        builder: (_, __) => const HomeScreen(),
      ),
    ],
  );
}
