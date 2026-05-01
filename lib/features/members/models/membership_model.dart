import 'package:mongo_dart/mongo_dart.dart';

class MembershipModel {
  final String id;
  final String memberId;
  final String planId;
  final String assignedTrainerId;
  final DateTime startDate;
  final DateTime expiryDate;
  final String paymentStatus;
  final DateTime createdAt;

  MembershipModel({
    this.id = '',
    required this.memberId,
    required this.planId,
    required this.assignedTrainerId,
    required this.startDate,
    required this.expiryDate,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> map) {
    return MembershipModel(
      id: (map['_id'] as ObjectId?)?.toHexString() ?? map['_id']?.toString() ?? '',
      memberId: (map['member_id'] as ObjectId?)?.toHexString() ?? map['member_id']?.toString() ?? '',
      planId: (map['plan_id'] as ObjectId?)?.toHexString() ?? map['plan_id']?.toString() ?? '',
      assignedTrainerId: (map['assigned_trainer_id'] as ObjectId?)?.toHexString() ?? map['assigned_trainer_id']?.toString() ?? '',

      startDate: map['start_date'] is DateTime
          ? map['start_date']
          : DateTime.tryParse(map['start_date']?.toString() ?? '') ??
              DateTime.now(),

      expiryDate: map['expiry_date'] is DateTime
          ? map['expiry_date']
          : DateTime.tryParse(map['expiry_date']?.toString() ?? '') ??
              DateTime.now(),

      paymentStatus: map['payment_status'] ?? '',

      createdAt: map['created_at'] is DateTime
          ? map['created_at']
          : DateTime.tryParse(map['created_at']?.toString() ?? '') ??
              DateTime.now(),
    );
  }

  // ✅ دي اللي الكونترولر محتاجها
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'start_date': startDate.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
      'payment_status': paymentStatus,
      'created_at': createdAt.toIso8601String(),
    };
    if (id.isNotEmpty) data['_id'] = ObjectId.parse(id);
    if (memberId.isNotEmpty) data['member_id'] = ObjectId.parse(memberId);
    if (planId.isNotEmpty) data['plan_id'] = ObjectId.parse(planId);
    if (assignedTrainerId.isNotEmpty) data['assigned_trainer_id'] = ObjectId.parse(assignedTrainerId);
    return data;
  }

  Map<String, dynamic> toJson() => toMap();
}