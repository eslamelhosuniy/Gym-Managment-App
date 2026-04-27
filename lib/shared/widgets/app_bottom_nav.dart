import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_router.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.dashboard);
        break;

      case 1:
        context.go(AppRouter.members);
        break;

      case 2:
        context.go(AppRouter.trainers);
        break;

      case 3:
        context.go(AppRouter.attendance);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.monitor_heart),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: "Members",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Trainers",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card),
          label: "Attendance",
        ),
      ],
    );
  }
}