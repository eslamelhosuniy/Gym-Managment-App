import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:gym_management_app/core/network/db_connection.dart';
import 'package:gym_management_app/features/members/models/member_model.dart';
import 'package:gym_management_app/features/members/controllers/member_controller.dart';
import '../models/attendance_model.dart';

class AttendanceController extends ChangeNotifier {
  final MemberController memberController;

  AttendanceController({required this.memberController});

  DbCollection get _attendanceCollection => DbConnection.instance.db.collection('attendance');

  List<AttendanceModel> attendanceHistory = [];
  bool isInitialLoading = false; // Used only when fetching the first page
  bool isPaginating = false;     // Used only when scrolling to fetch more pages
  bool isProcessing = false;     // Used when marking attendance (QR or Manual)
  bool hasMore = true;
  int currentPage = 0;
  final int limit = 20;
  String? errorMessage;

  /// Fetches attendance history with pagination
  Future<void> fetchAttendanceHistory({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (isPaginating || !hasMore) return;
      isPaginating = true;
      currentPage++;
    } else {
      isInitialLoading = true;
      currentPage = 0;
      hasMore = true;
      attendanceHistory.clear();
    }
    
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _attendanceCollection.find(
        where.sortBy('created_at', descending: true)
             .skip(currentPage * limit)
             .limit(limit),
      ).toList();

      final newRecords = data.map((e) => AttendanceModel.fromMap(e)).toList();
      
      if (newRecords.length < limit) {
        hasMore = false;
      }
      
      attendanceHistory.addAll(newRecords);
    } catch (e) {
      debugPrint("Error fetching attendance: $e");
      errorMessage = "Failed to load attendance history.";
    } finally {
      if (isLoadMore) {
        isPaginating = false;
      } else {
        isInitialLoading = false;
      }
      notifyListeners();
    }
  }

  /// Mark attendance using a QR Code ID
  Future<bool> markAttendanceByQr(String qrCodeId) async {
    try {
      isProcessing = true;
      errorMessage = null;
      notifyListeners();

      final member = await memberController.findByQrCode(qrCodeId);
      if (member == null) {
        errorMessage = "Invalid QR Code. Member not found.";
        return false;
      }

      return await _saveAttendance(member);
    } catch (e) {
      debugPrint("Error marking attendance via QR: $e");
      errorMessage = "Failed to mark attendance.";
      return false;
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  /// Mark attendance by selecting a MemberModel directly
  Future<bool> markAttendanceByMember(MemberModel member) async {
    try {
      isProcessing = true;
      errorMessage = null;
      notifyListeners();

      return await _saveAttendance(member);
    } catch (e) {
      debugPrint("Error marking attendance manually: $e");
      errorMessage = "Failed to mark attendance.";
      return false;
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  /// Helper method to save the attendance record
  Future<bool> _saveAttendance(MemberModel member) async {
    final now = DateTime.now();
    
    // Format date and time
    final dateStr = _formatDate(now);
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final attendance = AttendanceModel(
      id: '', // Empty ID, will be generated as ObjectId in toMap
      memberId: member.id, // MongoDB _id
      memberName: member.fullName,
      date: dateStr,
      time: timeStr,
      createdAt: now,
    );

    await _attendanceCollection.insert(attendance.toMap());
    
    // Add to local list and sort
    attendanceHistory.insert(0, attendance);
    _sortAttendance();
    
    return true;
  }

  /// Search members by name or phone (delegates to MemberController's in-memory list)
  Future<List<MemberModel>> searchMembers(String query) async {
    return await memberController.searchMembersLocally(query);
  }

  void _sortAttendance() {
    attendanceHistory.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  String _formatDate(DateTime date) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];

    return "$dayName, $monthName ${date.day}, ${date.year}";
  }
}
