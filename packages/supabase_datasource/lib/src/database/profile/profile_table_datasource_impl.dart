part of 'profile_table_datasource.dart';

class ProfileTableDataSourceImpl
    with SupabaseDataSourceExceptionHandlerMixIn
    implements ProfileTableDataSource {
  ProfileTableDataSourceImpl(this._client);

  final SupabaseClient _client;

  PostgrestQueryBuilder get _profiles =>
      _client.from(SupabaseTables.profiles.name);

  @override
  Future<void> deleteProfile(String id) {
    // TODO: implement deleteProfile
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> fetchProfile(String id) {
    // TODO: implement fetchProfile
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> updateProfile({required String id, String? displayName, String? avatarUrl, String? bio}) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

}
