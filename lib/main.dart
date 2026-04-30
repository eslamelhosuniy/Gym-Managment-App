import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/network/db_connection.dart';
import 'core/routing/app_router.dart';
import 'core/theme/theme.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/data/auth_local_service.dart';
import 'features/members/controllers/member_controller.dart'; 
import 'features/dashboard/controllers/dashboard_controller.dart'; 
import 'features/attendance/controllers/attendance_controller.dart';

Future<void> main() async {
  // Ensures that the Flutter engine is fully initialized before any
  // async work or plugin access happens.
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  try {
    await DbConnection.instance.connect();
  } on DbConnectionException catch (e) {
    dev.log('Startup: DB connection failed — $e', name: 'main', error: e);
  }
  runApp(const O2GymApp());
}

class O2GymApp extends StatelessWidget {
  const O2GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AuthController depends on AuthLocalService.
        ChangeNotifierProvider<AuthController>(
          create: (_) {
            final controller = AuthController(AuthLocalService());
            // Restore any existing session from local storage on boot.
            controller.tryRestoreSession();
            return controller;
          },
        ),
        ChangeNotifierProvider<MemberController>(
          create: (_) => MemberController(),
        ),
        ChangeNotifierProvider<DashboardController>(
          create: (_) => DashboardController(),
        ),
        ChangeNotifierProxyProvider<MemberController, AttendanceController>(
          create: (context) => AttendanceController(
            memberController: Provider.of<MemberController>(context, listen: false)
          ),
          update: (context, memberController, previous) =>
              previous ?? AttendanceController(memberController: memberController),
        ),
      ],
      child: Builder(                          
        builder: (context) {
          return MaterialApp.router(
            title: 'O2 Gym Management',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
          );
        },
      ),);
  }
}
