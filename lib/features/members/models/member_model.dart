

import 'package:mongo_dart/mongo_dart.dart';

class MemberModel {
  final String id;
  final int memberId;
  final String fullName;
  final String phoneNumber;
  final int age;
  final String gender;
  final String status;
  final DateTime joinedAt;
  final String qrCodeId;
  final String plan;
  final String trainer;
  final String startDate;
  final String expiryDate;
  final bool isPaid;

  const MemberModel({
    required this.id,
    required this.memberId,
    required this.fullName,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.status,
    required this.joinedAt,
    required this.qrCodeId,
    required this.plan,
    required this.trainer,
    required this.startDate,
    required this.expiryDate,
    required this.isPaid,
  });

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: (map['_id'] ?? '').toString(),
      memberId: map['id'] ?? 0,
      fullName: map['full_name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      status: map['status'] ?? '',
      joinedAt: map['joined_at'] is DateTime
          ? map['joined_at'] as DateTime
          : DateTime.tryParse(map['joined_at']?.toString() ?? '') ??
                DateTime.now(),
      qrCodeId: map['qr_code_id'] ?? '',
      plan: map['plan'] ?? '',
      trainer: map['trainer'] ?? '',
      startDate: map['start_date'] ?? '',
      expiryDate: map['expiry_date'] ?? '',
      isPaid: map['is_paid'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    '_id': id,
    'id': memberId,
    'full_name': fullName,
    'phone_number': phoneNumber,
    'age': age,
    'gender': gender,
    'status': status,
    'joined_at': joinedAt.toIso8601String(),
    'qr_code_id': qrCodeId,
    'plan': plan,
    'trainer': trainer,
    'start_date': startDate,
    'expiry_date': expiryDate,
    'is_paid': isPaid,
  };

  /// Returns a copy with modified fields (useful for renewMembership)
  MemberModel copyWith({
    String? id,
    int? memberId,
    String? fullName,
    String? phoneNumber,
    int? age,
    String? gender,
    String? status,
    DateTime? joinedAt,
    String? qrCodeId,
    String? plan,
    String? trainer,
    String? startDate,
    String? expiryDate,
    bool? isPaid,
  }) {
    return MemberModel(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      qrCodeId: qrCodeId ?? this.qrCodeId,
      plan: plan ?? this.plan,
      trainer: trainer ?? this.trainer,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  @override
  String toString() =>
      'MemberModel(id: $id, name: $fullName, phone: $phoneNumber, status: $status)';
}
