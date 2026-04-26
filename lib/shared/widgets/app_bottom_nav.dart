import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.monitor_heart),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Members"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Trainers"),
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card),
          label: "Attendance",
        ),
      ],
    );
  }
}
