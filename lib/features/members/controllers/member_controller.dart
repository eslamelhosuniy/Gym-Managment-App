// lib/features/members/controllers/member_controller.dart

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/member_model.dart';
import 'package:gym_management_app/core/network/db_connection.dart';

class MemberController extends ChangeNotifier {
  DbCollection get _collection =>
      DbConnection.instance.db.collection('members');

  // ── State ──────────────────────────────────────────────────────────────────

  List<MemberModel> members = [];
  bool isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  // ── Getters ────────────────────────────────────────────────────────────────

  String get selectedFilter => _selectedFilter;

  int get total => members.length;
  int get active => members.where((m) => m.status == 'Active').length;
  int get expired => members.where((m) => m.status == 'Expired').length;

  List<MemberModel> get filteredMembers {
    List<MemberModel> result = members;

    // Apply filter tab
    switch (_selectedFilter) {
      case 'Active':
        result = result.where((m) => m.status == 'Active').toList();
        break;
      case 'Expired':
        result = result.where((m) => m.status == 'Expired').toList();
        break;
      case 'Expiring Soon':
        final soon = DateTime.now().add(const Duration(days: 7));
        result = result.where((m) {
          final expiry = DateTime.tryParse(m.expiryDate);
          if (expiry == null) return false;
          return expiry.isAfter(DateTime.now()) && expiry.isBefore(soon);
        }).toList();
        break;
      default:
        break; // 'All' – no filter
    }

    // Apply search
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

  // ── Actions ────────────────────────────────────────────────────────────────

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  /// Fetches all members from MongoDB and recalculates statuses.
  Future<void> getMembers() async {
    isLoading = true;
    notifyListeners();

    try {
      final docs = await _collection.find().toList();
      members = docs.map((doc) {
        final model = MemberModel.fromMap(doc);
        // Auto-update status based on expiry date
        return model.copyWith(status: _resolveStatus(model.expiryDate));
      }).toList();
    } catch (e) {
      debugPrint('MemberController.getMembers error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new member to MongoDB and local list.
  Future<void> addMember({
    required String name,
    required String phone,
    required int age,
    required String gender,
    required String plan,
    required String trainer,
    required String startDate,
    String expiryDate = '',
  }) async {
    final member = MemberModel(
      id: ObjectId().toHexString(),
      memberId: DateTime.now().millisecondsSinceEpoch,
      fullName: name,
      phoneNumber: phone,
      age: age,
      gender: gender,
      plan: plan,
      trainer: trainer,
      startDate: startDate,
      expiryDate: expiryDate,
      isPaid: false,
      status: _resolveStatus(expiryDate),
      joinedAt: DateTime.now(),
      qrCodeId: 'QR_${DateTime.now().millisecondsSinceEpoch}',
    );

    await _collection.insert(member.toMap());

    members.add(member);
    notifyListeners();
  }

  /// Renews a member's membership by extending expiry by 30 days.
  Future<void> renewMembership(String memberId) async {
    final index = members.indexWhere((m) => m.id == memberId);
    if (index == -1) return;

    final current = members[index];
    final currentExpiry =
        DateTime.tryParse(current.expiryDate) ?? DateTime.now();
    final base = currentExpiry.isBefore(DateTime.now())
        ? DateTime.now()
        : currentExpiry;
    final newExpiry = base.add(const Duration(days: 30));
    final newExpiryStr =
        '${newExpiry.year}-${newExpiry.month.toString().padLeft(2, '0')}-${newExpiry.day.toString().padLeft(2, '0')}';

    final updated = current.copyWith(
      expiryDate: newExpiryStr,
      status: 'Active',
      isPaid: true,
    );

    await _collection.update(
      where.eq('_id', current.id),
      modify
          .set('expiry_date', newExpiryStr)
          .set('status', 'Active')
          .set('is_paid', true),
    );

    members[index] = updated;
    notifyListeners();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _resolveStatus(String expiryDate) {
    final expiry = DateTime.tryParse(expiryDate);
    if (expiry == null) return 'Active';
    return expiry.isBefore(DateTime.now()) ? 'Expired' : 'Active';
  }

  Future<dynamic> searchMembersLocally(String query) async {}

  Future<Object?> findByQrCode(String qrCodeId) async {}
}
