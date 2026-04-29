import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gym_management_app/features/auth/views/login_screen.dart';
import 'package:gym_management_app/features/members/views/add_member_screen.dart';
import 'package:gym_management_app/features/members/views/members_screen.dart';
import 'package:gym_management_app/features/dashboard/views/admin_dashboard_screen.dart';
import 'package:gym_management_app/features/trainers/views/trainers_list_screen.dart';
import 'package:gym_management_app/features/attendance/views/attendance_screen.dart';

import 'package:gym_management_app/core/layout/main_layout.dart';

class AppRouter {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String members = '/members';
  static const String addMember = '/add-member';
  static const String trainers = '/trainers';
  static const String attendance = '/attendance';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: dashboard,
            name: 'dashboard',
            builder: (context, state) => const AdminDashboardScreen(),
          ),

          GoRoute(
            path: members,
            name: 'members',
            builder: (context, state) => const MembersScreen(),
          ),

          GoRoute(
            path: trainers,
            name: 'trainers',
            builder: (context, state) => const TrainersListScreen(),
          ),

          GoRoute(
            path: attendance,
            name: 'attendance',
            builder: (context, state) => const AttendanceScreen(),
          ),
        

          GoRoute(
            path: addMember,
            name: 'addMember',
            builder: (context, state) => const AddMemberScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Route not found'))),
  );
}