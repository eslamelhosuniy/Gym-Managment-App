import 'package:mongo_dart/mongo_dart.dart';

class TrainerModel {
  final String id; // _id
  final String fullName;
  final String phoneNumber;
  final Map<String, dynamic>? schedule; // schedule_json
  final String bio;
  final DateTime createdAt;

  TrainerModel({
    this.id = '',
    required this.fullName,
    required this.phoneNumber,
    this.schedule,
    required this.bio,
    required this.createdAt,
  });
    @override
    bool operator ==(Object other) =>
        identical(this, other) || other is TrainerModel && other.id == id;

    @override
    int get hashCode => id.hashCode;
  // 🔹 From MAP
    factory TrainerModel.fromJson(Map<String, dynamic> map) {
    return TrainerModel(
      id: (map['_id'] as ObjectId?)?.toHexString() ?? map['_id']?.toString() ?? '',
      fullName: map['full_name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      schedule: map['schedule_json'],
      bio: map['bio'] ?? '',
      createdAt: map['created_at'] is DateTime
          ? map['created_at']
          : DateTime.tryParse(map['created_at']?.toString() ?? '') ??
              DateTime.now(),
    );
  }

  // 🔹 To JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'full_name': fullName,
      'phone_number': phoneNumber,
      'schedule_json': schedule,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
    };
    if (id.isNotEmpty) data['_id'] = ObjectId.parse(id);
    return data;
  }
}