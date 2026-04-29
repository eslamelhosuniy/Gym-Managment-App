import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../models/member_model.dart';
import 'package:gym_management_app/core/network/db_connection.dart';

class MemberController extends ChangeNotifier {
  DbCollection get _collection => DbConnection.instance.db.collection('members');

  List<MemberModel> members = [];

  bool isLoading = false;

  String selectedFilter = "All";
  String searchQuery = "";

  // 🔹 GET ALL
  Future<void> getMembers() async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _collection.find().toList();


       members = data.map((e) => MemberModel.fromMap(e)).toList();

    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 ADD MEMBER
  Future<void> addMember({
    required String name,
    required String phone,
    required int age,
  }) async {
    final member = MemberModel(
      id: ObjectId().toHexString(),
      memberId: _generateId(),
      fullName: name,
      phoneNumber: phone,
      age: age,
      gender: "unknown",
      status: "Active",
      joinedAt: DateTime.now(),
      qrCodeId: "QR_${DateTime.now().millisecondsSinceEpoch}",
    );

    await _collection.insert(member.toMap());

    members.add(member);
    notifyListeners();
  }

  // 🔹 FILTER + SEARCH
  List<MemberModel> get filteredMembers {
    List<MemberModel> list = selectedFilter == "All"
        ? members
        : members.where((m) => m.status == selectedFilter).toList();

    if (searchQuery.isNotEmpty) {
      list = list.where((m) {
        return m.fullName.toLowerCase().contains(searchQuery) ||
            m.phoneNumber.toLowerCase().contains(searchQuery);
      }).toList();
    }

    return list;
  }

  // 🔹 SET FILTER
  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  // 🔹 SEARCH
  void setSearch(String value) {
    searchQuery = value.toLowerCase();
    notifyListeners();
  }

  // 🔹 STATS
  int get total => members.length;
  int get active =>
      members.where((m) => m.status == "Active").length;
  int get expired =>
      members.where((m) => m.status == "Expired").length;

  int _generateId() {
    if (members.isEmpty) return 1;
    return members.map((e) => e.memberId).reduce((a, b) => a > b ? a : b) + 1;
  }
}