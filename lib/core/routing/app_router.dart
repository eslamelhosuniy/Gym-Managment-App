import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gym_management_app/features/auth/views/login_screen.dart';
import 'package:gym_management_app/features/members/models/member_model.dart';
import 'package:gym_management_app/features/members/views/add_member_screen.dart';
import 'package:gym_management_app/features/members/views/add_member_step2_screen.dart';
// import 'package:gym_management_app/features/members/views/member_details_screen.dart';
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
   static const String addMemberStep2 = '/add-member-step2';
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
          // GoRoute(
          //   path: '/member-details',
          //   name: 'memberDetails',
          //   builder: (context, state) {
          //     final member = state.extra as MemberModel;
          //     return MemberDetailsScreen(member: member);
          //   },
          // ),

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

          // ✅ Step 2 (مع parameter)
          GoRoute(
            path: '$addMemberStep2/:memberId',
            name: 'addMemberStep2',
            builder: (context, state) {
              final memberId = state.pathParameters['memberId']!;

              return AddMemberStep2Screen(
                memberId: memberId,
              );
            }
          )
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Route not found'))),
  );
}
