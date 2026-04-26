import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/theme.dart';
import 'package:gym_management_app/features/members/views/add_member_screen.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedFilter = "All";

  final List<Map<String, String>> members = [
    {"name": "Alice Brown", "phone": "+1 555-0001", "status": "Expiring Soon"},
    {"name": "Bob Wilson", "phone": "+1 555-0002", "status": "Expired"},
    {"name": "Carol Davis", "phone": "+1 555-0003", "status": "Active"},
    {"name": "David Martinez", "phone": "+1 555-0004", "status": "Expired"},
    {"name": "Emma Garcia", "phone": "+1 555-0005", "status": "Active"},
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Expired":
        return AppTheme.errorColor;
      default:
        return AppTheme.secondaryColor;
    }
  }

  List<Map<String, String>> get filteredMembers {
    final query = searchController.text.toLowerCase();
    List<Map<String, String>> list = selectedFilter == "All"
        ? members
        : members.where((m) => m["status"] == selectedFilter).toList();
    if (query.isNotEmpty) {
      list = list
          .where(
            (m) =>
                m["name"]!.toLowerCase().contains(query) ||
                m["phone"]!.toLowerCase().contains(query),
          )
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () {
              // Navigate to AddMemberScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMemberScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Header Stats ──
          Container(
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Row(
              children: [
                _StatChip(
                  label: "Total",
                  count: members.length,
                  color: Colors.white24,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: "Active",
                  count: members.where((m) => m["status"] == "Active").length,
                  color: Colors.green.withOpacity(0.25),
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: "Expired",
                  count: members.where((m) => m["status"] == "Expired").length,
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
                    hintText: "Search by name or phone",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ["All", "Active", "Expired", "Expiring Soon"].map(
                      (filter) {
                        final isSelected = selectedFilter == filter;
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
                                setState(() => selectedFilter = filter),
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
                  "${filteredMembers.length} member${filteredMembers.length != 1 ? 's' : ''}",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── List ──
          Expanded(
            child: filteredMembers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 60,
                          color: AppTheme.textSecondaryColor.withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No members found",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = filteredMembers[index];
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
                            backgroundColor: AppTheme.primaryColor.withOpacity(
                              0.1,
                            ),
                            child: Text(
                              member["name"]![0],
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            member["name"]!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            member["phone"]!,
                            style: theme.textTheme.bodyMedium,
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(
                                member["status"]!,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: getStatusColor(
                                  member["status"]!,
                                ).withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              member["status"]!,
                              style: TextStyle(
                                color: getStatusColor(member["status"]!),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
            "$count",
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
