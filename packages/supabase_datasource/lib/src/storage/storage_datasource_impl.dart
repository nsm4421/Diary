part of 'storage_datasource.dart';

class SupabaseStorageDataSourceImpl
    with SupabaseDataSourceExceptionHandlerMixIn
    implements SupabaseStorageDataSource {
  final SupabaseClient _client;
  final String _bucket;

  SupabaseStorageDataSourceImpl({
    required SupabaseClient client,
    required String bucket,
  }) : _client = client,
       _bucket = bucket;

  @override
  Future<String> createSignedUrl({
    required String path,
    required Duration expiresIn,
    TransformOptions? transform,
  }) async {
    try {
      return await _client.storage
          .from(_bucket)
          .createSignedUrl(path, expiresIn.inSeconds, transform: transform);
    } catch (e, st) {
      throw toApiException(e, st);
    }
  }

  @override
  String getPublicUrl({required String path, TransformOptions? transform}) {
    try {
      return _client.storage
          .from(_bucket)
          .getPublicUrl(path, transform: transform);
    } catch (e, st) {
      throw toApiException(e, st);
    }
  }

  @override
  Future<void> remove(String path) async {
    try {
      await _client.storage.from(_bucket).remove([path]);
    } catch (e, st) {
      throw toApiException(e, st);
    }
  }

  @override
  Future<void> removeAll(Iterable<String> paths) async {
    try {
      await _client.storage.from(_bucket).remove(paths.toList());
    } catch (e, st) {
      throw toApiException(e, st);
    }
  }

  @override
  Future<String> uploadBinary({
    required String path,
    required List<int> fileBytes,
    FileOptions options = const FileOptions(),
    StorageRetryController? retryController,
  }) async {
    try {
      final bytes = fileBytes is Uint8List
          ? fileBytes
          : Uint8List.fromList(fileBytes);
      return await _client.storage
          .from(_bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: options,
            retryController: retryController,
          );
    } catch (e, st) {
      throw toApiException(e, st);
    }
  }

  @override
  Future<String> uploadFile({
    required String path,
    required File file,
    FileOptions options = const FileOptions(),
    StorageRetryController? retryController,
  }) async {
    try {
      return await _client.storage
          .from(_bucket)
          .upload(
            path,
            file,
            fileOptions: options,
            retryController: retryController,
          );
    } catch (e, st) {
      throw toApiException(e, st);
    }
  }
}
