class AuthUserModel {
  final String id;
  final String email;
  final String? username;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AuthUserModel({
    required this.id,
    required this.email,
    this.username,
    this.createdAt,
    this.updatedAt,
  });
}
