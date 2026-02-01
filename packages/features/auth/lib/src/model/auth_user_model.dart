import 'package:shared/shared.dart';

class AuthUserModel extends ProfileModel {
  final String email;

  AuthUserModel({
    required super.id,
    required this.email,
    super.username,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
  });

  AuthUserModel copyWith({
    required String username,
    required String? avatarUrl,
  }) {
    return AuthUserModel(
      id: id,
      email: email,
      username: username,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension AuthUserModelExtension on AuthUserModel {
  ProfileModel toProfile() {
    return ProfileModel(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
