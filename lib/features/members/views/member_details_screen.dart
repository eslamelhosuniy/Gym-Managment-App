

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_management_app/features/members/controllers/member_controller.dart';
import 'package:gym_management_app/features/members/models/member_model.dart';

class MemberDetailsScreen extends StatelessWidget {
  // ✅ Uses MemberModel (not a separate Member class)
  final MemberModel member;

  const MemberDetailsScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final isExpired =
        DateTime.tryParse(member.expiryDate)?.isBefore(DateTime.now()) ?? false;

    // Watch controller so UI rebuilds after renewMembership
    final controller = context.watch<MemberController>();

    // Get the latest version of this member from controller (in case it was updated)
    final liveMember = controller.members.firstWhere(
      (m) => m.id == member.id,
      orElse: () => member,
    );

    return Scaffold(
      appBar: AppBar(title: Text(liveMember.fullName)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      liveMember.fullName[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    liveMember.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${liveMember.memberId}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),

            // ── Personal Info ──
            _SectionTitle('Personal Info'),
            _InfoRow(Icons.phone_outlined, 'Phone', liveMember.phoneNumber),
            _InfoRow(Icons.cake_outlined, 'Age', '${liveMember.age}'),
            _InfoRow(Icons.wc_outlined, 'Gender', liveMember.gender),

            const SizedBox(height: 16),
            const Divider(),

            // ── Membership ──
            _SectionTitle('Membership'),
            _InfoRow(Icons.card_membership_outlined, 'Plan', liveMember.plan),
            _InfoRow(Icons.person_outline, 'Trainer', liveMember.trainer),
            _InfoRow(
              Icons.calendar_today_outlined,
              'Start Date',
              liveMember.startDate,
            ),
            _InfoRow(
              Icons.event_busy_outlined,
              'Expiry Date',
              liveMember.expiryDate,
              valueColor: isExpired ? Colors.red : Colors.green,
            ),

            const SizedBox(height: 16),
            const Divider(),

            // ── Payment ──
            _SectionTitle('Payment'),
            Row(
              children: [
                const Icon(
                  Icons.payment_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                const Text('Status: '),
                Chip(
                  label: Text(
                    liveMember.isPaid ? 'Paid' : 'Pending',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: liveMember.isPaid
                      ? Colors.green
                      : Colors.orange,
                ),
              ],
            ),

            const Spacer(),

            // ── Renew Button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await context.read<MemberController>().renewMembership(
                    liveMember.id,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Membership renewed for 30 days ✅'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.autorenew),
                label: const Text('Renew Membership'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────

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
