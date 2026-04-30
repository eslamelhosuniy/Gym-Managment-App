

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/member_controller.dart';

class AddMemberStep2Screen extends StatefulWidget {
  final String name;
  final String phone;
  final int age;
  final String gender;

  const AddMemberStep2Screen({
    super.key,
    required this.name,
    required this.phone,
    required this.age,
    required this.gender,
  });

  @override
  State<AddMemberStep2Screen> createState() => _AddMemberStep2ScreenState();
}

class _AddMemberStep2ScreenState extends State<AddMemberStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final startDateController = TextEditingController();

  String? selectedPlan;
  String? selectedTrainer;
  bool isSaving = false;

  // ── Options ────────────────────────────────────────────────────────────────

  static const List<String> plans = [
    'Monthly',
    'Quarterly',
    'Semi-Annual',
    'Annual',
  ];

  static const List<String> trainers = [
    'Ahmed Ali',
    'Mohamed Hassan',
    'Sara Khaled',
    'Omar Samir',
    'Nour Adel',
  ];

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
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      await context.read<MemberController>().addMember(
        name: widget.name,
        phone: widget.phone,
        age: widget.age,
        gender: widget.gender,
        plan: selectedPlan!,
        trainer: selectedTrainer!,
        startDate: startDateController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member added successfully!')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 2 – Membership')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Step 1 Summary ──
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${widget.name} · ${widget.phone} · Age ${widget.age} · ${widget.gender}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Plan Dropdown ──
              DropdownButtonFormField<String>(
                value: selectedPlan,
                decoration: const InputDecoration(
                  labelText: 'Plan',
                  prefixIcon: Icon(Icons.card_membership_outlined),
                ),
                items: plans
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => selectedPlan = v),
                validator: (v) => v == null ? 'Please select a plan' : null,
              ),
              const SizedBox(height: 12),

              // ── Trainer Dropdown ──
              DropdownButtonFormField<String>(
                value: selectedTrainer,
                decoration: const InputDecoration(
                  labelText: 'Trainer',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: trainers
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => selectedTrainer = v),
                validator: (v) => v == null ? 'Please select a trainer' : null,
              ),
              const SizedBox(height: 12),

              // ── Start Date ──
              TextFormField(
                controller: startDateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 28),

              // ── Save Button ──
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
