import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:gym_management_app/core/network/db_connection.dart';

class DashboardController extends ChangeNotifier {
  Db get _db => DbConnection.instance.db;

  bool isLoading = false;
  String? errorMessage;

  int totalMembers = 0;
  int activeMembers = 0;
  int expiredMembers = 0;
  int todayAttendance = 0;

  Future<void> loadDashboardData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final membersCollection = _db.collection('members');

      // ── Members ─────────────────────────────
      totalMembers = await membersCollection.count();

      activeMembers = await membersCollection.count(
            where.eq('status', 'Active'),
          ) ??
          0;

      expiredMembers = await membersCollection.count(
            where.eq('status', 'Expired'),
          ) ??
          0;

      // ── Attendance ──────────────────────────
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final attendanceCollection = _db.collection('attendance');

      todayAttendance = await attendanceCollection.count(
            where
                .gte('check_in_date', startOfDay)
                .lt('check_in_date', endOfDay),
          ) ??
          0;
    } catch (e, st) {
      dev.log(
        'loadDashboardData failed',
        error: e,
        stackTrace: st,
        name: 'DashboardController',
      );
      errorMessage = 'Failed to load dashboard: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}