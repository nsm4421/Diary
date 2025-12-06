class AuthUserEntity {
  const AuthUserEntity({
    required this.id,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.bio,
  });

  final String id;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
}
