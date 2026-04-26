import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/routing/app_router.dart';

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
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  List<Map<String, String>> get filteredMembers {
    if (selectedFilter == "All") return members;
    return members.where((m) => m["status"] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRouter.addMember),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by name or phone",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),

            const SizedBox(height: 12),

            // 🔘 Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "Active", "Expired", "Expiring Soon"].map((
                  filter,
                ) {
                  final isSelected = selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // 📋 List
            Expanded(
              child: ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(member["name"]!),
                      subtitle: Text(member["phone"]!),

                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(member["status"]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          member["status"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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
      ),
    );
  }
}
