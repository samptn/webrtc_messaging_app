import 'package:go_router/go_router.dart';
import 'package:webrtc_messaging_app/views/chat/calling_screen.dart';
import 'package:webrtc_messaging_app/views/chat/chat_screen.dart';
import '/routes/app_routes.dart';

import '../views/home/home_screen.dart';

class AppPages {
  static GoRouter routerConfig = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (_, __) => const ChatScreen(),
      ),
       GoRoute(
        path: AppRoutes.calling,
        builder: (_, __) => const CallingScreen(),
      ),
    ],
  );
}
