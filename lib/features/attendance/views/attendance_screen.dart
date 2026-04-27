import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<Map<String, dynamic>> attendanceHistory = [
    {
      "name": "John Smith",
      "date": "Mon, Jan 5, 2026",
      "time": "18:30",
      "createdAt": DateTime(2026, 1, 5, 18, 30),
    },
    {
      "name": "Sarah Johnson",
      "date": "Mon, Jan 5, 2026",
      "time": "08:30",
      "createdAt": DateTime(2026, 1, 5, 8, 30),
    },
    {
      "name": "Mike Chen",
      "date": "Mon, Jan 5, 2026",
      "time": "07:00",
      "createdAt": DateTime(2026, 1, 5, 7, 0),
    },
    {
      "name": "John Smith",
      "date": "Sun, Jan 4, 2026",
      "time": "09:15",
      "createdAt": DateTime(2026, 1, 4, 9, 15),
    },
  ];

  String _formatDate(DateTime date) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];

    return "$dayName, $monthName ${date.day}, ${date.year}";
  }

  void _sortAttendance() {
    attendanceHistory.sort(
      (a, b) => b["createdAt"].compareTo(a["createdAt"]),
    );
  }

  void markAttendance({String name = "Manual Check-in"}) {
    final now = DateTime.now();

    setState(() {
      attendanceHistory.add({
        "name": name,
        "date": _formatDate(now),
        "time":
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
        "createdAt": now,
      });

      _sortAttendance();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Attendance marked for $name"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> scanQrCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      ),
    );

    if (result != null) {
      markAttendance(name: result.toString());
    }
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
    _sortAttendance();

    return SafeArea(
      child: ListView(
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
                  onPressed: () {
                    markAttendance();
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text("Mark Attendance"),
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
                const Text(
                  "Attendance History",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...attendanceHistory.map(
                  (item) => Column(
                    children: [
                      attendanceItem(
                        name: item["name"],
                        date: item["date"],
                        time: item["time"],
                      ),
                      const Divider(height: 1),
                    ],
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