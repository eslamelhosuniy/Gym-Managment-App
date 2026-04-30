class PlanModel {
  final String id;
  final int planId;
  final String planName;
  final int durationDays;
  final int price;

  PlanModel({
    required this.id,
    required this.planId,
    required this.planName,
    required this.durationDays,
    required this.price,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PlanModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  // ✅ fromMap — reads from MongoDB document
  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['_id'].toString(),
      planId: map['id'] ?? 0,
      planName: map['plan_name'] ?? '',
      durationDays: map['duration_days'] ?? 0,
      price: num.tryParse(map['price'].toString())?.toInt() ?? 0,
    );
  }

  // ✅ toMap — sends to MongoDB
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'id': planId,
      'plan_name': planName,
      'duration_days': durationDays,
      'price': price,
    };
  }
}