import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'add_member_step2_screen.dart';
import '../controllers/member_controller.dart';

class MemberDetailsScreen extends StatefulWidget {
  const MemberDetailsScreen({super.key});

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  Map<String, dynamic>? memberData;
  bool isLoading = true;
  bool isPaid = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final memberId =
          GoRouterState.of(context).pathParameters['id'] ?? '';

      final controller = context.read<MemberController>();

      final data = await controller.getMemberDetails(memberId);

      setState(() {
        memberData = data;
        isPaid = (data?['paymentStatus'] ?? '') == 'Paid';
        isLoading = false;
      });
    });
  }

  Future<void> togglePaymentStatus() async {
    final controller = context.read<MemberController>();

    final newStatus = isPaid ? 'Pending' : 'Paid';

    setState(() {
      isPaid = !isPaid; // UI update فوري
    });

    try {
      await controller.updatePaymentStatus(
        memberData!['membershipId'].oid,
        newStatus,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated to $newStatus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {

      debugPrint('eeeeeee $e');
      // rollback لو فشل
      setState(() {
        isPaid = !isPaid;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> reloadMember() async {
    final memberId =
        GoRouterState.of(context).pathParameters['id'] ?? '';

    final controller = context.read<MemberController>();

    final data = await controller.getMemberDetails(memberId);

    setState(() {
      memberData = data;
      isPaid = (data?['paymentStatus'] ?? '') == 'Paid';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (memberData == null) {
      return const Scaffold(
        body: Center(child: Text("No Data Found")),
      );
    }

    final memberId =
        GoRouterState.of(context).pathParameters['id'] ?? 'Unknown';

    final String fullName = memberData!['fullName'] ?? '';
    final String phone = memberData!['phone'] ?? '';
    final int age = memberData!['age'] ?? 0;
    final String gender = memberData!['gender'] ?? '';

    final String plan = memberData!['plan'] ?? 'No Plan';
    final String trainer = memberData!['trainer'] ?? 'No Trainer';

    final String startDate =
        memberData!['startDate']?.toString().split('T')[0] ?? '';

    final String expiryDate =
        memberData!['expiryDate']?.toString().split('T')[0] ?? '';

    final bool isExpired =
        DateTime.tryParse(expiryDate)?.isBefore(DateTime.now()) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(fullName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/members');
            }
          },
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    fullName.isNotEmpty ? fullName[0] : '?',
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
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Member ID: $memberId',
                  style:
                      const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),

          // Personal Info
          const _SectionTitle('Personal Info'),
          _InfoRow(Icons.phone_outlined, 'Phone', phone),
          _InfoRow(Icons.cake_outlined, 'Age', '$age'),
          _InfoRow(Icons.wc_outlined, 'Gender', gender),

          const SizedBox(height: 16),
          const Divider(),

          // Membership
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

          // Payment
          const _SectionTitle('Payment'),
          Row(
            children: [
              const Icon(Icons.payment_outlined,
                  size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              const Text('Status: '),

              const SizedBox(width: 8),

              GestureDetector(
                onTap: togglePaymentStatus,
                child: Chip(
                  label: Text(
                    isPaid ? 'Paid' : 'Pending',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor:
                      isPaid ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddMemberStep2Screen(
                      memberId: memberData!['_id'].oid,
                      fromDetails: true,
                    ),
                  ),
                );

                if (result == true) {
                  reloadMember(); // 👈 هنكتبها دلوقتي
                }
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

// Helpers

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.icon, this.label, this.value,
      {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor),
          ),
        ],
      ),
    );
  }
}