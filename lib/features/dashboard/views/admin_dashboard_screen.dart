import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

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
    return SafeArea(
      child: ListView(
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
            value: "5",
          ),
          buildCard(
            icon: Icons.person,
            color: Colors.green,
            title: "Active Members",
            value: "2",
          ),
          buildCard(
            icon: Icons.person_off,
            color: Colors.red,
            title: "Expired Members",
            value: "2",
          ),
          buildCard(
            icon: Icons.access_time,
            color: Colors.orange,
            title: "Expiring in 7 Days",
            value: "1",
          ),
          buildCard(
            icon: Icons.monitor_heart,
            color: Colors.purple,
            title: "Today's Attendance",
            value: "4",
          ),
        ],
      ),
    );
  }
}