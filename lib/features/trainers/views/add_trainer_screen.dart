import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controllers/trainer_controller.dart';
import '../models/trainer_model.dart';
import '../../../core/routing/app_router.dart';
import 'package:provider/provider.dart';

class AddTrainerScreen extends StatefulWidget {
  const AddTrainerScreen({super.key});

  @override
  State<AddTrainerScreen> createState() => _AddTrainerScreenState();
}

class _AddTrainerScreenState extends State<AddTrainerScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController bioController = TextEditingController();

  Map<String, Map<String, dynamic>> schedule = {
    "sunday": {"from": "", "to": "", "active": false},
    "monday": {"from": "", "to": "", "active": false},
    "tuesday": {"from": "", "to": "", "active": false},
    "wednesday": {"from": "", "to": "", "active": false},
    "thursday": {"from": "", "to": "", "active": false},
  };

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
    List<String> days = schedule.keys.toList();

    return Column(
      children: days.map((day) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: schedule[day]!["active"],
                      onChanged: (val) {
                        setState(() {
                          schedule[day]!["active"] = val;
                        });
                      },
                    ),
                    Text(day.toUpperCase()),
                  ],
                ),

                if (schedule[day]!["active"] == true)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "From",
                          ),
                          onChanged: (val) {
                            schedule[day]!["from"] = val;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "To",
                          ),
                          onChanged: (val) {
                            schedule[day]!["to"] = val;
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> saveTrainer() async {
    if (_formKey.currentState!.validate()) {

      setState(() => isLoading = true);

    final filteredSchedule = Map.fromEntries(
      schedule.entries.where((entry) => entry.value["active"] == true),
    );

      await context.read<TrainerController>().addTrainer(
        fullName: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        bio: bioController.text.trim(),
        schedule: filteredSchedule,
      );

      setState(() => isLoading = false);

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
                label: "Bio",
                icon: Icons.description,
                controller: bioController,
              ),

              const Text(
                "Working Schedule",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              scheduleBox(),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: isLoading ? null : saveTrainer,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save, color: Colors.white),
                      label: const Text("Save Trainer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}