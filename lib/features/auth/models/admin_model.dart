
class AdminModel {
  final String id;
  final String email;
  final String fullName;

  const AdminModel({
    required this.id,
    required this.email,
    required this.fullName,
  });


  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      email: map['email'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'full_name': fullName,
      };

  @override
  String toString() => 'AdminModel(id: $id, email: $email, name: $fullName)';
}
