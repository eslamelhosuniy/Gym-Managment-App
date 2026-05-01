import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/routing/app_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  int _getIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(AppRouter.dashboard)) return 0;
    if (location.startsWith(AppRouter.members)) return 1;
    if (location.startsWith(AppRouter.plans)) return 2;
    if (location.startsWith(AppRouter.trainers)) return 3;
    if (location.startsWith(AppRouter.attendance)) return 4;

    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.dashboard);
        break;
      case 1:
        context.go(AppRouter.members);
        break;
      case 2:
        context.go(AppRouter.plans);
        break;
      case 3:
        context.go(AppRouter.trainers);
        break;
      case 4:
        context.go(AppRouter.attendance);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Members",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: "Plans",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Trainers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Attendance",
          ),
        ],
      ),
    );
  }
}