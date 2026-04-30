class MembershipModel {
  final int memberShipId;
  final int memberId;
  final int planId;
  final int assignedTrainerId;
  final DateTime startDate;
  final DateTime expiryDate;
  final String paymentStatus;
  final DateTime createdAt;

  MembershipModel({
    required this.memberShipId,
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
      memberShipId: map['id'] ?? 0,
      memberId: map['member_id'] ?? 0,
      planId: map['plan_id'] ?? 0,
      assignedTrainerId: map['assigned_trainer_id'] ?? 0,

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
    return {
      'id': memberShipId,
      'member_id': memberId,
      'plan_id': planId,
      'assigned_trainer_id': assignedTrainerId,
      'start_date': startDate.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
      'payment_status': paymentStatus,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() => toMap();
}