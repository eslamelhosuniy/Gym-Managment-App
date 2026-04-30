import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gym_management_app/core/theme/theme.dart';
import 'package:gym_management_app/features/members/views/add_member_screen.dart';
import 'package:gym_management_app/features/members/views/member_details_screen.dart';
import 'package:gym_management_app/features/members/controllers/member_controller.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemberController>().getMembers();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Expired':
        return AppTheme.errorColor;
      default:
        return AppTheme.secondaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<MemberController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () async {
              await context.pushNamed('addMember');
              controller.getMembers();
            },
          ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Header Stats ──
                Container(
                  color: AppTheme.primaryColor,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Row(
                    children: [
                      _StatChip(
                        label: 'Total',
                        count: controller.total,
                        color: Colors.white24,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        label: 'Active',
                        count: controller.active,
                        color: Colors.green.withOpacity(0.25),
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        label: 'Expired',
                        count: controller.expired,
                        color: Colors.red.withOpacity(0.25),
                      ),
                    ],
                  ),
                ),

                // ── Search + Filters ──
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search by name or phone',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: controller.setSearch,
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              ['All', 'Active', 'Expired', 'Expiring Soon'].map(
                                (filter) {
                                  final isSelected =
                                      controller.selectedFilter == filter;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(
                                        filter,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppTheme.textSecondaryColor,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      selected: isSelected,
                                      selectedColor: AppTheme.primaryColor,
                                      backgroundColor: AppTheme.surfaceColor,
                                      side: BorderSide(
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : Colors.grey.shade300,
                                      ),
                                      onSelected: (_) =>
                                          controller.setFilter(filter),
                                    ),
                                  );
                                },
                              ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Member Count Label ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        '${controller.filteredMembers.length} member${controller.filteredMembers.length != 1 ? 's' : ''}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // ── List ──
                Expanded(
                  child: controller.filteredMembers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_search,
                                size: 60,
                                color: AppTheme.textSecondaryColor.withOpacity(
                                  0.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No members found',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: controller.filteredMembers.length,
                          itemBuilder: (context, index) {
                            final member = controller.filteredMembers[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: AppTheme.primaryColor
                                      .withOpacity(0.1),
                                  child: Text(
                                    member.fullName[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  member.fullName,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  member.phoneNumber,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                      member.status,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: getStatusColor(
                                        member.status,
                                      ).withOpacity(0.4),
                                    ),
                                  ),
                                  child: Text(
                                    member.status,
                                    style: TextStyle(
                                      color: getStatusColor(member.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // // ✅ Navigate to details on tap
                                // onTap: () {
                                //   context.pushNamed(
                                //     'memberDetails',
                                //     extra: member,
                                //   );
                                // },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

// ── _StatChip ──────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
