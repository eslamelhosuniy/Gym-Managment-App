import 'package:mongo_dart/mongo_dart.dart';

class AttendanceModel {
  final String id;
  final String memberId;
  final String memberName;
  final String date;
  final String time;
  final DateTime createdAt;

  const AttendanceModel({
    this.id = '',
    required this.memberId,
    required this.memberName,
    required this.date,
    required this.time,
    required this.createdAt,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: (map['_id'] as ObjectId?)?.toHexString() ?? map['_id']?.toString() ?? '',
      memberId: (map['member_id'] as ObjectId?)?.toHexString() ?? map['member_id']?.toString() ?? '',
      memberName: map['member_name']?.toString() ?? 'Unknown',
      date: map['date']?.toString() ?? '',
      time: map['time']?.toString() ?? '',
      createdAt: map['created_at'] is DateTime
          ? map['created_at'] as DateTime
          : DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'member_name': memberName,
      'date': date,
      'time': time,
      'created_at': createdAt,
    };
    if (id.isNotEmpty) {
      data['_id'] = ObjectId.parse(id);
    }
    if (memberId.isNotEmpty) {
      data['member_id'] = ObjectId.parse(memberId);
    }
    return data;
  }

  @override
  String toString() {
    return 'AttendanceModel(id: $id, memberName: $memberName, date: $date, time: $time)';
  }
}
