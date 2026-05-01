import 'package:mongo_dart/mongo_dart.dart';

class AdminModel {
  final String id;
  final String email;
  final String fullName;

  const AdminModel({
    this.id = '',
    required this.email,
    required this.fullName,
  });

  /// From MongoDB document (contains ObjectId)
  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: (map['_id'] is ObjectId)
          ? (map['_id'] as ObjectId).toHexString()
          : map['_id']?.toString() ?? '',
      email: map['email'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
    );
  }

  /// For MongoDB operations (ObjectId)
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'email': email,
      'full_name': fullName,
    };
    if (id.isNotEmpty) {
      data['_id'] = ObjectId.parse(id);
    }
    return data;
  }

  /// For local storage (SharedPreferences) — plain JSON-safe types only
  Map<String, dynamic> toJsonLocal() => {
        '_id': id,
        'email': email,
        'full_name': fullName,
      };

  @override
  String toString() => 'AdminModel(id: $id, email: $email, name: $fullName)';
}
