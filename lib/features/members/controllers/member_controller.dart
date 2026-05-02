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
        result = result.where((m) => m.status == 'Expired').toList();
        break;
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where(
            (m) =>
                m.fullName.toLowerCase().contains(q) ||
                m.phoneNumber.contains(q),
          )
          .toList();
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

  Future<Map<String, dynamic>?> getMemberDetails(String memberId) async {
    try {
      final objectId = ObjectId.parse(memberId);

      final pipeline = [
        // 1. member
        {
          r'$match': {'_id': objectId}
        },

        // 2. membership
        {
          r'$lookup': {
            'from': 'memberships',
            'let': {'memberId': r'$_id'},
            'pipeline': [
              {
                r'$match': {
                  r'$expr': {
                    r'$eq': [r'$member_id', r'$$memberId']
                  }
                }
              },

              // 🔥 نحول created_at من String لـ Date
              {
                r'$addFields': {
                  'createdAtDate': {r'$toDate': r'$created_at'}
                }
              },

              // 🔥 نرتب صح
              {
                r'$sort': {'createdAtDate': -1}
              },

              // 🔥 ناخد آخر واحدة بس
              {
                r'$limit': 1
              }
            ],
            'as': 'membership'
          }
        },

        {
          r'$unwind': {
            'path': r'$membership',
            'preserveNullAndEmptyArrays': true
          }
        },

        // 3. plan
        {
          r'$lookup': {
            'from': 'plans',
            'localField': 'membership.plan_id',
            'foreignField': '_id',
            'as': 'plan'
          }
        },

        {
          r'$unwind': {
            'path': r'$plan',
            'preserveNullAndEmptyArrays': true
          }
        },

        // 4. trainer
        {
          r'$lookup': {
            'from': 'trainers',
            'localField': 'membership.assigned_trainer_id',
            'foreignField': '_id',
            'as': 'trainer'
          }
        },

        {
          r'$unwind': {
            'path': r'$trainer',
            'preserveNullAndEmptyArrays': true
          }
        },

        // 5. الشكل النهائي
        {
          r'$project': {
            '_id': 1,

            'membershipId': r'$membership._id',

            'fullName': r'$full_name',
            'phone': r'$phone_number',
            'age': 1,
            'gender': 1,
            'status': 1,

            'plan': r'$plan.plan_name',
            'trainer': r'$trainer.full_name',

            'startDate': r'$membership.start_date',
            'expiryDate': r'$membership.expiry_date',
            'paymentStatus': r'$membership.payment_status',
          }
        }
      ];

      final result =
          await _collection.aggregateToStream(pipeline).toList();

      debugPrint('member ship ${result.first}');

      if (result.isEmpty) return null;

      return result.first;
    } catch (e) {
      debugPrint("❌ getMemberDetails error: $e");
      return null;
    }
  }

  Future<void> updatePaymentStatus(String membershipId, String status) async {
    final objectId = ObjectId.parse(membershipId);

    await _membershipsCollection.updateOne(
      where.eq('_id', objectId),  
      modify.set('payment_status', status),
    );
  }

  Future<void> addMembership({
    required String memberId,
    required String planId,
    required String assignedTrainerId,
    required DateTime startDate,
    required DateTime expiryDate,
  }) async {
    final memberShip = MembershipModel(
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
    debugPrint("memberId: ${memberShip.memberId}");
    debugPrint("planId: ${memberShip.planId}");
    debugPrint("trainerId: ${memberShip.assignedTrainerId}");
    debugPrint("startDate: ${memberShip.startDate}");
    debugPrint("expiryDate: ${memberShip.expiryDate}");

    final doc = memberShip.toMap();
    await _membershipsCollection.insert(doc);

    debugPrint("✅ Inserted to MongoDB successfully!");

    final insertedMembership = MembershipModel.fromJson(doc);
    memberShips.add(insertedMembership);
    notifyListeners();
  }

  Future<MemberModel> addMember({
    required String name,
    required String phone,
    required int age,
    required String gender,
  }) async {
    final member = MemberModel(
      fullName: name,
      phoneNumber: phone,
      age: age,
      gender: gender,
      status: "Active",
      joinedAt: DateTime.now(),
      qrCodeId: "QR_${DateTime.now().millisecondsSinceEpoch}",
    );

    try {
      final doc = member.toMap();
      await _collection.insert(doc);

      final insertedMember = MemberModel.fromMap(doc);
      members.add(insertedMember);
      notifyListeners();

      debugPrint('*********member ${insertedMember}');
      return insertedMember;
    } catch (e, stack) {
      print("❌ Insert error: $e");
      print(stack);
      rethrow; // so the UI SnackBar shows
    }
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

  Future<MemberModel?> findByQrCode(String qrCode) async {
    debugPrint("QR Code: $qrCode");

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
    var localResults = members
        .where(
          (m) =>
              m.fullName.toLowerCase().contains(q) ||
              m.phoneNumber.toLowerCase().contains(q) ||
              m.id.toString() == q,
        )
        .toList();

    // 2. Fallback to Database if no local results found
    if (localResults.isEmpty) {
      try {
        final dbData = await _collection
            .find(
              where
                  .match('full_name', q, caseInsensitive: true)
                  .or(where.match('phone_number', q))
                  .or(where.eq('id', int.tryParse(q) ?? -1))
                  .limit(10), // Limit DB search to 10
            )
            .toList();

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
