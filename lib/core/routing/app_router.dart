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
import 'package:gym_management_app/features/trainers/views/trainer_details_screen.dart';
import 'package:gym_management_app/features/trainers/views/add_trainer_screen.dart';
import 'package:gym_management_app/features/attendance/views/attendance_screen.dart';
import 'package:gym_management_app/features/auth/controllers/auth_controller.dart';
import 'package:gym_management_app/features/plans/views/plans_screen.dart';
import 'package:gym_management_app/features/plans/views/plan_details_screen.dart';
import 'package:gym_management_app/features/plans/views/add_plan_screen.dart';

import 'package:gym_management_app/core/layout/main_layout.dart';

class AppRouter {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String members = '/members';
  static const String addMember = '/add-member';
  static const String addMemberStep2 = '/add-member-step2';
  static const String trainers = '/trainers';
  static const String addTrainer = '/add-trainer';
  static const String attendance = '/attendance';
  static const String plans = '/plans';
  static const String addPlan = '/add-plan';

  static GoRouter createRouter(AuthController authController) {
    return GoRouter(
      initialLocation: dashboard,
      debugLogDiagnostics: true,
      refreshListenable: authController,
      redirect: (context, state) {
        final bool loggedIn = authController.isAuthenticated;
        final bool loggingIn = state.matchedLocation == login;

        if (!loggedIn) {
          return loggingIn ? null : login;
        }

        // If logged in and at login page, go to dashboard
        if (loggingIn) {
          return dashboard;
        }

        return null;
      },
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
              path: '/trainers/:id',
              name: 'trainerDetails',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? '';
                return TrainerDetailsScreen(trainerId: id);
              },
            ),

            GoRoute(
              path: attendance,
              name: 'attendance',
              builder: (context, state) => const AttendanceScreen(),
            ),

            GoRoute(
              path: plans,
              name: 'plans',
              builder: (context, state) => const PlansScreen(),
            ),

            GoRoute(
              path: '/plans/:id',
              name: 'planDetails',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? '';
                return PlanDetailsScreen(planId: id);
              },
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
              },
            ),
          ],
        ),

        GoRoute(
          path: addPlan,
          name: 'addPlan',
          builder: (context, state) => const AddPlanScreen(),
        ),

        GoRoute(
          path: addTrainer,
          name: 'addTrainer',
          builder: (context, state) => const AddTrainerScreen(),
        ),
      ],
      errorBuilder: (context, state) =>
          const Scaffold(body: Center(child: Text('Route not found'))),
    );
  }
}