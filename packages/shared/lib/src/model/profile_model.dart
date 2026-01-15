import 'package:shared/shared.dart';

class ProfileModel extends BaseModel {
  @override
  final String id;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  final String username;
  final String? avatarUrl;

  ProfileModel({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.username = '익명',
    this.avatarUrl,
  });
}
