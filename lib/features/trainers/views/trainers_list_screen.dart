import 'package:flutter/material.dart';

class TrainersListScreen extends StatelessWidget {
  const TrainersListScreen({super.key});

  Widget trainerCard({
    required String name,
    required String phone,
    required String members,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            child: Icon(Icons.person),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(phone),
              Text(members, style: const TextStyle(color: Colors.grey)),
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
            "Trainers",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            "View all gym trainers",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          trainerCard(
            name: "John Smith",
            phone: "+1 234-567-8901",
            members: "15 assigned members",
          ),
          trainerCard(
            name: "Sarah Johnson",
            phone: "+1 234-567-8902",
            members: "12 assigned members",
          ),
          trainerCard(
            name: "Mike Chen",
            phone: "+1 234-567-8903",
            members: "18 assigned members",
          ),
        ],
      ),
    );
  }
}