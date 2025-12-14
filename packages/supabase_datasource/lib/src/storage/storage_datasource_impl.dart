part of 'storage_datasource.dart';

class SupabaseStorageDataSourceImpl
    with SupabaseDataSourceExceptionHandlerMixIn
    implements SupabaseStorageDataSource {
  final SupabaseClient _client;

  SupabaseStorageDataSourceImpl(this._client);

  @override
  Future<String> createSignedUrl({
    required String bucket,
    required String path,
    required Duration expiresIn,
    TransformOptions? transform,
  }) async {
    try {
      return await _client.storage
          .from(bucket)
          .createSignedUrl(path, expiresIn.inSeconds, transform: transform);
    } catch (e, st) {
      throw toApiException(e, st);
    }
  }

  @override
  String getPublicUrl({
    required String bucket,
    required String path,
    TransformOptions? transform,
  }) {
    try {
      return _client.storage
          .from(bucket)
          .getPublicUrl(path, transform: transform);
    } catch (e, st) {
      throw toApiException(e, st);
    }
  }

  @override
  Future<void> remove({required String bucket, required String path}) async {
    try {
      await _client.storage.from(bucket).remove([path]);
    } catch (e, st) {
      throw toApiException(e, st);
    }
  }

  @override
  Future<void> removeAll({
    required String bucket,
    required Iterable<String> paths,
  }) async {
    try {
      await _client.storage.from(bucket).remove(paths.toList());
    } catch (e, st) {
      throw toApiException(e, st);
    }
  }

  @override
  Future<String> uploadBinary({
    required String bucket,
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
          .from(bucket)
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
    required String bucket,
    required String path,
    required File file,
    FileOptions options = const FileOptions(),
    StorageRetryController? retryController,
  }) async {
    try {
      return await _client.storage
          .from(bucket)
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

  @override
  Future<String> upsertFile({
    required String bucket,
    required String path,
    required File file,
    StorageRetryController? retryController,
  }) async {
    return await this.uploadFile(
      bucket: bucket,
      path: path,
      file: file,
      options: FileOptions(upsert: true),
      retryController: retryController
    );
  }
}
