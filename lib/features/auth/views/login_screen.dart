import 'package:flutter/material.dart';
// import 'package:gym_management_app/core/routing/app_router.dart';
import 'package:gym_management_app/core/theme/theme.dart';
// import 'package:gym_management_app/core/constants/app_strings.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Icon(Icons.favorite, color: AppTheme.primaryColor, size: 60),

              const SizedBox(height: 10),

              Text("O2 Gym", style: theme.textTheme.displayLarge),

              const SizedBox(height: 5),

              Text("Welcome back", style: theme.textTheme.bodyMedium),

              const SizedBox(height: 30),

              // Email
              TextField(
                decoration: const InputDecoration(
                  labelText: "Email / Phone",
                  hintText: "Enter your email or phone",
                ),
              ),

              const SizedBox(height: 15),

              // Password
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Login"),
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () {},
                child: const Text("Forgot password?"),
              ),

              const SizedBox(height: 20),

              // Demo
              Text(
                "Demo credentials:\nAdmin: admin@o2gym.com / admin",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
