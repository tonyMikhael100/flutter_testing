import 'package:flutter/material.dart';
import 'package:flutter_testing/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // ── مفتاح التنقل العام — يُستخدم في Dio Interceptor للتنقل بدون context ──
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// مراقب التنقل — يُستخدم في HomeScreen لإعادة جلب البيانات عند العودة
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  static String loginScreen = '/loginScreen';
  static String splashScreen = '/splashScreen';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: splashScreen,
    observers: [routeObserver],
    routes: [
      GoRoute(
        path: splashScreen,
        builder: ((context, state) => SplashScreen()),
      ),
      GoRoute(path: loginScreen, builder: (context, state) => Placeholder()),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
