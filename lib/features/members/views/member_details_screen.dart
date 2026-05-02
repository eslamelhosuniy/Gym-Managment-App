import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemberDetailsScreen extends StatelessWidget {
  const MemberDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Get ID from route
    final memberId =
        GoRouterState.of(context).pathParameters['id'] ?? 'Unknown';

    // ── Dummy Data ──
    final String fullName = "Ahmed Mohamed";
    final String phone = "01012345678";
    final int age = 25;
    final String gender = "Male";

    final String plan = "Gold";
    final String trainer = "Coach Ali";
    final String startDate = "2024-01-01";
    final String expiryDate = "2024-02-01";

    final bool isPaid = true;

    final bool isExpired =
        DateTime.tryParse(expiryDate)?.isBefore(DateTime.now()) ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(fullName)),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Avatar + Name ──
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  child: Text(
                    fullName[0],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Member ID: $memberId',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),

          // ── Personal Info ──
          const _SectionTitle('Personal Info'),
          _InfoRow(Icons.phone_outlined, 'Phone', phone),
          _InfoRow(Icons.cake_outlined, 'Age', '$age'),
          _InfoRow(Icons.wc_outlined, 'Gender', gender),

          const SizedBox(height: 16),
          const Divider(),

          // ── Membership ──
          const _SectionTitle('Membership'),
          _InfoRow(Icons.card_membership_outlined, 'Plan', plan),
          _InfoRow(Icons.person_outline, 'Trainer', trainer),
          _InfoRow(Icons.calendar_today_outlined, 'Start Date', startDate),
          _InfoRow(
            Icons.event_busy_outlined,
            'Expiry Date',
            expiryDate,
            valueColor: isExpired ? Colors.red : Colors.green,
          ),

          const SizedBox(height: 16),
          const Divider(),

          // ── Payment ──
          const _SectionTitle('Payment'),
          Row(
            children: [
              const Icon(Icons.payment_outlined, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              const Text('Status: '),
              Chip(
                label: Text(
                  isPaid ? 'Paid' : 'Pending',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: isPaid ? Colors.green : Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // ── Button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dummy Action 🚀'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              icon: const Icon(Icons.autorenew),
              label: const Text('Renew Membership'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.icon, this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }
}
