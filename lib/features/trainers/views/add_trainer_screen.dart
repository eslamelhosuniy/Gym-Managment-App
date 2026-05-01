import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';

class AddTrainerScreen extends StatefulWidget {
  const AddTrainerScreen({super.key});

  @override
  State<AddTrainerScreen> createState() => _AddTrainerScreenState();
}

class _AddTrainerScreenState extends State<AddTrainerScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController specializationController =
      TextEditingController();

  Widget inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget scheduleBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Row(
        children: [
          Icon(Icons.schedule, color: Colors.grey),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Schedule will be configured later",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  void saveTrainer() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Trainer saved successfully"),
          backgroundColor: Colors.green,
        ),
      );

      context.go(AppRouter.trainers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Trainer"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.trainers),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Create New Trainer",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Add a new gym trainer",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 24),

              inputField(
                label: "Full Name",
                icon: Icons.person,
                controller: nameController,
              ),

              inputField(
                label: "Phone Number",
                icon: Icons.phone,
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),

              inputField(
                label: "Specialization",
                icon: Icons.fitness_center,
                controller: specializationController,
              ),

              scheduleBox(),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: saveTrainer,
                icon:
                    const Icon(Icons.save, color: Colors.white),
                label: const Text("Save Trainer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}