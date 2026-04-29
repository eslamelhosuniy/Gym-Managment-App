import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_management_app/core/theme/theme.dart';
import 'package:gym_management_app/features/members/controllers/member_controller.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final planController = TextEditingController();
  final startDateController = TextEditingController();
  final expiryDateController = TextEditingController();

  bool _isSaving = false; // 🔹 loading state

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primaryColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> saveMember() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await context.read<MemberController>().addMember(
            name: nameController.text.trim(),
            phone: phoneController.text.trim(),
            age: int.tryParse(ageController.text.trim()) ?? 0,
          );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add member: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Member")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Section: Personal Info ──
              _SectionHeader(title: "Personal Information"),
              const SizedBox(height: 12),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name *",
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number *",
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Phone is required" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
              ),

              const SizedBox(height: 24),

              // ── Section: Membership ──
              _SectionHeader(title: "Membership Details"),
              const SizedBox(height: 12),

              TextFormField(
                controller: planController,
                decoration: const InputDecoration(
                  labelText: "Plan Type",
                  prefixIcon: Icon(Icons.card_membership_outlined),
                  hintText: "e.g. Monthly, Quarterly, Annual",
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: startDateController,
                readOnly: true,
                onTap: () => _pickDate(startDateController),
                decoration: const InputDecoration(
                  labelText: "Start Date",
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  hintText: "Select date",
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: expiryDateController,
                readOnly: true,
                onTap: () => _pickDate(expiryDateController),
                decoration: const InputDecoration(
                  labelText: "Expiry Date",
                  prefixIcon: Icon(Icons.event_outlined),
                  hintText: "Select date",
                ),
              ),

              const SizedBox(height: 32),

              // ── Save Button ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : saveMember,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(_isSaving ? "Saving..." : "Add Member"),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textSecondaryColor,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 16,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}