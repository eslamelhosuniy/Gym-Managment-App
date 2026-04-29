import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/dashboard_controller.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<DashboardController>().loadDashboardData());
  }

  Widget buildCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DashboardController>();

    return SafeArea(
      child: ctrl.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ctrl.errorMessage != null
              ? Center(child: Text(ctrl.errorMessage!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      "Admin Dashboard",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Overview of gym metrics",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    buildCard(
                      icon: Icons.people,
                      color: Colors.blue,
                      title: "Total Members",
                      value: ctrl.totalMembers.toString(),
                    ),
                    buildCard(
                      icon: Icons.person,
                      color: Colors.green,
                      title: "Active Members",
                      value: ctrl.activeMembers.toString(),
                    ),
                    buildCard(
                      icon: Icons.person_off,
                      color: Colors.red,
                      title: "Expired Members",
                      value: ctrl.expiredMembers.toString(),
                    ),
                    buildCard(
                      icon: Icons.monitor_heart,
                      color: Colors.purple,
                      title: "Today's Attendance",
                      value: ctrl.todayAttendance.toString(),
                    ),
                  ],
                ),
    );
  }
}