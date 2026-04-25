import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/routing/app_router.dart';
import 'core/theme/theme.dart';

void main() async {
  // Ensures that Flutter engine is fully initialized before async tasks
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // TODO: Initialize database connection here later
  // await DbConnection.connect();

  runApp(const O2GymApp());
}

class O2GymApp extends StatelessWidget {
  const O2GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We use MaterialApp.router to integrate with go_router
    return MaterialApp.router(
      title: 'O2 Gym Management',
      debugShowCheckedModeBanner: false,
      
      // Applying the central theme we created earlier
      theme: AppTheme.lightTheme,
      
      // Hooking up our customized Router
      routerConfig: AppRouter.router,
    );
  }
}
