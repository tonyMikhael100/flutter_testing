import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing/core/dependency_injection/dependency_injection.dart';
import 'package:flutter_testing/features/chats/presentation/cubits/cubit/chat_cubit.dart';
import 'package:flutter_testing/features/chats/presentation/screens/chat_screen.dart';
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
  static String chatScreen = '/chatScreen';

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
      GoRoute(
        path: chatScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ChatCubit>(),
          child: ChatScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
