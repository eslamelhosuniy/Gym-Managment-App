import 'package:mongo_dart/mongo_dart.dart';

class AttendanceModel {
  final String id;
  final String memberId;
  final String memberName;
  final String date;
  final String time;
  final DateTime createdAt;

  const AttendanceModel({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.date,
    required this.time,
    required this.createdAt,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: (map['_id'] ?? '').toString(),
      memberId: map['member_id']?.toString() ?? '',
      memberName: map['member_name']?.toString() ?? 'Unknown',
      date: map['date']?.toString() ?? '',
      time: map['time']?.toString() ?? '',
      createdAt: map['created_at'] is DateTime
          ? map['created_at'] as DateTime
          : DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id.isEmpty ? ObjectId() : (ObjectId.tryParse(id) ?? id),
      'member_id': memberId,
      'member_name': memberName,
      'date': date,
      'time': time,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'AttendanceModel(id: $id, memberName: $memberName, date: $date, time: $time)';
  }
}
