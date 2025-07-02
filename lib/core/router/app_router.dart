import 'package:basic_navigation/core/di/injection.dart';
import 'package:basic_navigation/core/router/go_router_refresh_stream.dart';
import 'package:basic_navigation/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:basic_navigation/features/auth/presentation/view/login_page.dart';
import 'package:basic_navigation/features/home/presentation/view/home_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter returnRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: "/login",

      // Docs: https://docs.page/csells/go_router/redirection#refreshing-with-a-stream
      // ChatGPT discussion: https://chatgpt.com/share/68657fca-9e14-800c-9e9a-8dd0e39b3fb3
      // Listen to the AuthBloc stream to automatically refresh the router
      refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),

      routes: [
        GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
        GoRoute(path: "/home", builder: (context, state) => const HomePage()),
      ],

      redirect: (context, state) {
        final authState = getIt<AuthBloc>().state;
        final isAuthenticated = authState.status == AuthStatus.authenticated;

        // The location the user is trying to access
        final loggingIn = state.matchedLocation == "/login";

        // If not logged in and not on the login page -> redirect to login
        if (!isAuthenticated && !loggingIn) {
          return "/login";
        }

        // If already logged in and on the login page -> redirect to home
        if (isAuthenticated && loggingIn) {
          return "/home";
        }

        // In other cases, no redirection needed
        return null;
      },
    );
  }
}
