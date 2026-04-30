import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/attendance_controller.dart';
import '../../members/models/member_model.dart';
import 'qr_scanner_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        context.read<AttendanceController>().fetchAttendanceHistory(isLoadMore: true);
      }
    });

    // Fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceController>().fetchAttendanceHistory();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> scanQrCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      ),
    );

    if (result != null && mounted) {
      final controller = context.read<AttendanceController>();
      final success = await controller.markAttendanceByQr(result.toString());

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Attendance marked successfully"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.errorMessage ?? "Failed to mark attendance"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showManualAttendanceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const _ManualAttendanceDialog();
      },
    );
  }

  Widget attendanceItem({
    required String name,
    required String date,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.green, size: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AttendanceController>();

    return SafeArea(
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Attendance",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Mark your daily attendance",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Mark Attendance",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _showManualAttendanceDialog,
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text("Search Member Manually"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: scanQrCode,
                  icon: const Icon(Icons.qr_code, color: Colors.black87),
                  label: const Text("Scan QR Code"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Attendance History",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (controller.isInitialLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                  ],
                ),
                const SizedBox(height: 16),
                if (controller.attendanceHistory.isEmpty && !controller.isInitialLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "No attendance records found.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...controller.attendanceHistory.map(
                    (item) => Column(
                      children: [
                        attendanceItem(
                          name: item.memberName,
                          date: item.date,
                          time: item.time,
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                if (controller.isPaginating)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualAttendanceDialog extends StatefulWidget {
  const _ManualAttendanceDialog();

  @override
  State<_ManualAttendanceDialog> createState() => _ManualAttendanceDialogState();
}

class _ManualAttendanceDialogState extends State<_ManualAttendanceDialog> {
  MemberModel? selectedMember;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AttendanceController>();

    return AlertDialog(
      title: const Text("Search Member"),
      content: SizedBox(
        width: double.maxFinite,
        child: Autocomplete<MemberModel>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<MemberModel>.empty();
            }
            return await controller.searchMembers(textEditingValue.text);
          },
          displayStringForOption: (MemberModel option) => "${option.fullName} (${option.phoneNumber})",
          onSelected: (MemberModel selection) {
            setState(() {
              selectedMember = selection;
            });
          },
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: "Enter name or phone",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: selectedMember == null
              ? null
              : () async {
                  final success = await controller.markAttendanceByMember(selectedMember!);
                  if (mounted) {
                    Navigator.pop(context);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Attendance marked for ${selectedMember!.fullName}"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(controller.errorMessage ?? "Error marking attendance"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
          child: const Text("Mark"),
        ),
      ],
    );
  }
}