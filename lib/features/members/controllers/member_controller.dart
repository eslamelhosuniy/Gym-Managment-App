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
  bool _hasFetchedMembers = false;

  // 🔹 GET ALL
  Future<void> getMembers() async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _collection.find().toList();


       members = data.map((e) => MemberModel.fromMap(e)).toList();
       _hasFetchedMembers = true;

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

  Future<MemberModel?> findByQrCode(String qrCode) async {
    // 1. Search locally first
    final localMatch = members.where((m) => m.qrCodeId == qrCode).firstOrNull;
    
    if (localMatch != null) {
      return localMatch;
    }

    // 2. Fallback to Database
    try {
      final data = await _collection.findOne(where.eq('qr_code_id', qrCode));
        if (data != null) {
          final member = MemberModel.fromMap(data);
          // Cache it locally
          if (!members.any((m) => m.id == member.id)) {
            members.add(member);
          }
          return member;
        }
      } catch (dbError) {
        debugPrint("Error fetching QR from DB: $dbError");
      }
      return null;
  }

  Future<List<MemberModel>> searchMembersLocally(String query) async {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    
    // 1. Search locally first
    var localResults = members.where((m) => 
      m.fullName.toLowerCase().contains(q) || 
      m.phoneNumber.toLowerCase().contains(q) ||
      m.memberId.toString() == q
    ).toList();

    // 2. Fallback to Database if no local results found
    if (localResults.isEmpty) {
      try {
        final dbData = await _collection.find(
          where.match('full_name', q, caseInsensitive: true)
               .or(where.match('phone_number', q))
               .or(where.eq('id', int.tryParse(q) ?? -1))
               .limit(10) // Limit DB search to 10
        ).toList();

        final dbResults = dbData.map((e) => MemberModel.fromMap(e)).toList();
        
        // Cache DB results locally
        for (var member in dbResults) {
          if (!members.any((m) => m.id == member.id)) {
            members.add(member);
          }
        }
        return dbResults;
      } catch (dbError) {
        debugPrint("Error searching members in DB: $dbError");
        return [];
      }
    }

    return localResults;
  }
}