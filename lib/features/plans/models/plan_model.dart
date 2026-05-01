import 'package:mongo_dart/mongo_dart.dart';

class PlanModel {
  final String id;
  final String planName;
  final int durationDays;
  final int price;

  PlanModel({
    this.id = '',
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
      id: (map['_id'] as ObjectId?)?.toHexString() ?? map['_id']?.toString() ?? '',
      planName: map['plan_name'] ?? '',
      durationDays: map['duration_days'] ?? 0,
      price: num.tryParse(map['price'].toString())?.toInt() ?? 0,
    );
  }

  // ✅ toMap — sends to MongoDB
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'plan_name': planName,
      'duration_days': durationDays,
      'price': price,
    };
    if (id.isNotEmpty) data['_id'] = ObjectId.parse(id);
    return data;
  }
}