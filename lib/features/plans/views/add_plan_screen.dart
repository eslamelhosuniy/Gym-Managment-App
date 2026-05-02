import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routing/app_router.dart';
import '../controllers/plan_controller.dart';
import 'package:go_router/go_router.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Widget inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future<void> _savePlan() async {
    final name = nameController.text.trim();
    final duration = int.tryParse(durationController.text.trim()) ?? 0;
    final price = int.tryParse(priceController.text.trim()) ?? 0;

    if (name.isEmpty || duration <= 0 || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid data")),
      );
      return;
    }

    try {
      await context.read<PlanController>().addPlan(
            planName: name,
            durationDays: duration,
            price: price,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Plan added successfully")),
      );

      context.go(AppRouter.plans);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Plan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.plans),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Create New Plan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            inputField(
              label: "Plan Name",
              icon: Icons.card_membership,
              controller: nameController,
            ),
            inputField(
              label: "Duration Days",
              icon: Icons.timer,
              controller: durationController,
              keyboardType: TextInputType.number,
            ),
            inputField(
              label: "Price",
              icon: Icons.attach_money,
              controller: priceController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _savePlan,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text("Save Plan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}