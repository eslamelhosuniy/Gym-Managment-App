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

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: (map['_id'] as ObjectId?)?.toHexString() ?? map['_id']?.toString() ?? '',
      email: map['email'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
    );
  }

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

  @override
  String toString() => 'AdminModel(id: $id, email: $email, name: $fullName)';
}
