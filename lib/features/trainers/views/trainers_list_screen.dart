import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/trainer_controller.dart';

class TrainersListScreen extends StatefulWidget {
  const TrainersListScreen({super.key});

  @override
  State<TrainersListScreen> createState() => _TrainersListScreenState();
}

class _TrainersListScreenState extends State<TrainersListScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrainerController>().getTrainers();
    });
  }

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
          const CircleAvatar(child: Icon(Icons.person)),
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
      child: Consumer<TrainerController>(
        builder: (context, controller, child) {

          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          if (controller.trainers.isEmpty) {
            return const Center(child: Text("No trainers found"));
          }

          return ListView(
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

              ...controller.trainers.map((trainer) {
                return trainerCard(
                  name: trainer.fullName,
                  phone: trainer.phoneNumber,
                  members: "Assigned members",
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}