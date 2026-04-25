import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // Define route paths as constants to avoid typos
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String members = '/members';

  // Singleton instance of GoRouter
  static final GoRouter router = GoRouter(
    initialLocation: login,
    debugLogDiagnostics: true,
    
    // Global Redirect (Middleware / Guard)
    redirect: (BuildContext context, GoRouterState state) {
      // TODO: Implement actual authentication check here using Provider/SecureStorage
      const bool isAuthenticated = false; 
      
      final bool isGoingToLogin = state.matchedLocation == login;

      // If the user is not authenticated and trying to access a secure page, redirect to login
      if (!isAuthenticated && !isGoingToLogin) {
        return login;
      }

      // If the user is authenticated and trying to access the login page, redirect to dashboard
      if (isAuthenticated && isGoingToLogin) {
        return dashboard;
      }

      // No redirect needed
      return null;
    },

    routes: <RouteBase>[
      GoRoute(
        path: login,
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          // TODO: Replace with actual LoginScreen when features are refactored
          return const Scaffold(
            body: Center(child: Text('Login Screen (Under Construction)')),
          );
        },
      ),
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (BuildContext context, GoRouterState state) {
           // TODO: Replace with actual DashboardScreen
          return const Scaffold(
            body: Center(child: Text('Dashboard Screen (Secure)')),
          );
        },
      ),
    ],
    
    // Error Page Builder
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.error}'),
      ),
    ),
  );
}
