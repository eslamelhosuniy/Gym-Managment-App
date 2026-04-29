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
        : DateTime.tryParse(map['joined_at']?.toString() ?? '') ?? DateTime.now(),
      qrCodeId: map['qr_code_id'] ?? '',
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
      };

  @override
  String toString() {
    return 'MemberModel(id: $id, name: $fullName, phone: $phoneNumber, status: $status )';
  }
}