// lib/features/members/controllers/member_controller.dart

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/member_model.dart';
import '../models/membership_model.dart';
import 'package:gym_management_app/core/network/db_connection.dart';

class MemberController extends ChangeNotifier {
  DbCollection get _collection =>
      DbConnection.instance.db.collection('members');

  DbCollection get _membershipsCollection =>
      DbConnection.instance.db.collection('memberships');

  List<MemberModel> members = [];
  List<MembershipModel> memberShips = [];

  bool isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  String get selectedFilter => _selectedFilter;

  int get total => members.length;
  int get active => members.where((m) => m.status == 'Active').length;
  int get expired => members.where((m) => m.status == 'Expired').length;

  List<MemberModel> get filteredMembers {
    List<MemberModel> result = members;

    switch (_selectedFilter) {
      case 'Active':
        result = result.where((m) => m.status == 'Active').toList();
        break;
      case 'Expired':
        result = result.where((m) => m.status == 'Expired').toList();
        break;
      case 'Expiring Soon':
        result = result.where((m) =>
          m.status == 'Expired'
        ).toList();
        break;
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((m) =>
          m.fullName.toLowerCase().contains(q) ||
          m.phoneNumber.contains(q)).toList();
    }

    return result;
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> getMembers() async {
    isLoading = true;
    notifyListeners();

    try {

      final data = await _collection.find().toList();
      print("DATA FROM DB: $data");

      members = data.map((e) => MemberModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('getMembers error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMembership({
    required int memberId,
    required int planId,
    required int assignedTrainerId,
    required DateTime startDate,
    required DateTime expiryDate,
  }) async {
    final memberShip = MembershipModel(
      memberShipId: 11237,
      memberId: memberId,
      planId: planId,
      assignedTrainerId: assignedTrainerId,
      startDate: startDate,
      expiryDate: expiryDate,
      paymentStatus: 'Pending',
      createdAt: DateTime.now(),
    );

    // 🖨️ Print 2 — what's being inserted into DB
    debugPrint("=== INSERT TO DB ===");
    debugPrint("memberShipId: ${memberShip.memberShipId}");
    debugPrint("memberId: ${memberShip.memberId}");
    debugPrint("planId: ${memberShip.planId}");
    debugPrint("trainerId: ${memberShip.assignedTrainerId}");
    debugPrint("startDate: ${memberShip.startDate}");
    debugPrint("expiryDate: ${memberShip.expiryDate}");
    debugPrint("map: ${memberShip.toMap()}"); // 🔥 shows exact DB document

    await _membershipsCollection.insert(memberShip.toMap());

    debugPrint("✅ Inserted to MongoDB successfully!");

    memberShips.add(memberShip);
    notifyListeners();
  }

  Future<MemberModel> addMember({
    required String name,
    required String phone,
    required int age,
    required String gender,
  }) async {
    final member = MemberModel(
      memberId: 98763,
      fullName: name,
      phoneNumber: phone,
      age: age,
      gender: gender,
      status: "Active",
      joinedAt: DateTime.now(),
      qrCodeId: "QR_${DateTime.now().millisecondsSinceEpoch}",
    );

    try {
      await _collection.insert(member.toMap());
      members.add(member);
      notifyListeners();

      debugPrint('*********member ${member}');
    } catch (e, stack) {
      print("❌ Insert error: $e");
      print(stack);
      rethrow; // so the UI SnackBar shows
    }

    return member;
  }
  // Future<void> renewMembership(String memberId) async {
  //   final index = members.indexWhere((m) => m.id == memberId);
  //   if (index == -1) return;

  //   final current = members[index];
  //   final currentExpiry =
  //       DateTime.tryParse(current.expiryDate) ?? DateTime.now();

  //   final base = currentExpiry.isBefore(DateTime.now())
  //       ? DateTime.now()
  //       : currentExpiry;

  //   final newExpiry = base.add(const Duration(days: 30));

  //   final newExpiryStr =
  //       '${newExpiry.year}-${newExpiry.month.toString().padLeft(2, '0')}-${newExpiry.day.toString().padLeft(2, '0')}';

  //   final updated = current.copyWith(
  //     expiryDate: newExpiryStr,
  //     status: 'Active',
  //     isPaid: true,
  //   );

  //   await _collection.update(
  //     where.eq('_id', current.id),
  //     modify
  //         .set('expiry_date', newExpiryStr)
  //         .set('status', 'Active')
  //         .set('is_paid', true),
  //   );

  //   members[index] = updated;
  //   notifyListeners();
  // }


  Future<dynamic> searchMembersLocally(String query) async {}
  Future<Object?> findByQrCode(String qrCodeId) async {}
}