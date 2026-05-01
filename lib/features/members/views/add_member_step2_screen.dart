import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gym_management_app/features/members/controllers/member_controller.dart';
import 'package:gym_management_app/features/plans/controllers/plan_controller.dart';
import 'package:gym_management_app/features/trainers/controllers/trainer_controller.dart';
import 'package:gym_management_app/features/plans/models/plan_model.dart';

class AddMemberStep2Screen extends StatefulWidget {
  final String memberId;

  const AddMemberStep2Screen({
    super.key,
    required this.memberId,
  });

  @override
  State<AddMemberStep2Screen> createState() => _AddMemberStep2ScreenState();
}

class _AddMemberStep2ScreenState extends State<AddMemberStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final startDateController = TextEditingController();

  PlanModel? selectedPlan;
  String? selectedTrainerId;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<PlanController>().getPlansForDropdown();
      await context.read<TrainerController>().getTrainersForDropdown();
    });
  }
  @override
  void dispose() {
    startDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      startDateController.text =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedPlan == null || selectedTrainerId == null) return;

    setState(() => isSaving = true);

    // 🖨️ Print 1 — what we're sending
    debugPrint("=== SAVE MEMBERSHIP ===");
    debugPrint("memberId: ${widget.memberId}");
    debugPrint("planId: ${selectedPlan!.id}");
    debugPrint("planName: ${selectedPlan!.planName}");
    debugPrint("trainerId: $selectedTrainerId");
    debugPrint("startDate: ${startDateController.text}");

    try {
      final startDate = DateTime.parse(startDateController.text);
      final expiryDate = startDate.add(Duration(days: selectedPlan!.durationDays));

      debugPrint("expiryDate: $expiryDate");

      await context.read<MemberController>().addMembership(
        memberId: widget.memberId,
        planId: selectedPlan!.id,
        assignedTrainerId: selectedTrainerId!,
        startDate: startDate,
        expiryDate: expiryDate,
      );

      if (!mounted) return;

      debugPrint("✅ Membership saved successfully!");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully!')),
      );

      Navigator.popUntil(context, (route) => route.isFirst);

    } catch (e) {
      debugPrint("❌ Error saving membership: $e"); // ✅ now you'll see errors
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),      // ✅ user sees error too
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final planController = context.watch<PlanController>();
    final trainerController = context.watch<TrainerController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Step 2 – Membership')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Member ID: ${widget.memberId}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Plan
              planController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<PlanModel>(
                  value: selectedPlan,
                  decoration: const InputDecoration(
                    labelText: 'Plan',
                    prefixIcon: Icon(Icons.card_membership_outlined),
                  ),
                  items: planController.plans.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(p.planName),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => selectedPlan = v),
                  validator: (v) => v == null ? 'Please select a plan' : null,
                ),

              const SizedBox(height: 12),

              // ✅ Trainer
              trainerController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<String>(
                  value: selectedTrainerId,
                  decoration: const InputDecoration(
                    labelText: 'Trainer',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: trainerController.trainers.map<DropdownMenuItem<String>>((t) {
                    return DropdownMenuItem<String>(
                      value: t.id,
                      child: Text(t.fullName),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => selectedTrainerId = v),
                  validator: (v) => v == null ? 'Please select a trainer' : null,
                ),

              const SizedBox(height: 12),

              // ✅ Start Date
              TextFormField(
                controller: startDateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 28),

              ElevatedButton.icon(
                onPressed: isSaving ? null : _save,
                icon: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(isSaving ? 'Saving...' : 'Finish & Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}