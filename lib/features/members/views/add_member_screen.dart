import 'package:flutter/material.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final planController = TextEditingController();
  final startDateController = TextEditingController();
  final expiryDateController = TextEditingController();

  void saveMember() {
    final name = nameController.text;
    final phone = phoneController.text;

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required fields")),
      );
      return;
    }

    // 🔥 هنا لاحقًا هتربطه ب API أو State Management
    // print("Member Saved: $name - $phone");

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Member")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: "Age"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: planController,
              decoration: const InputDecoration(labelText: "Plan Type"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: startDateController,
              decoration: const InputDecoration(labelText: "Start Date"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: expiryDateController,
              decoration: const InputDecoration(labelText: "Expiry Date"),
            ),

            const SizedBox(height: 25),

            // 🔥 زرار الإضافة هنا
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveMember,
                child: const Text("Add Member"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
