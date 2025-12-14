import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/datasource_exception_handler.dart';

part 'storage_datasource_impl.dart';

/// Storage operations for working with Supabase buckets.
abstract interface class SupabaseStorageDataSource {
  /// Uploads a file from disk.
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required File file,
    FileOptions options = const FileOptions(),
    StorageRetryController? retryController,
  });

  Future<String> upsertFile({
    required String bucket,
    required String path,
    required File file,
    StorageRetryController? retryController,
  });

  /// Uploads in-memory bytes.
  Future<String> uploadBinary({
    required String bucket,
    required String path,
    required List<int> fileBytes,
    FileOptions options = const FileOptions(),
    StorageRetryController? retryController,
  });

  /// Returns a public URL for a file (works on public buckets).
  String getPublicUrl({
    required String bucket,
    required String path,
    TransformOptions? transform,
  });

  /// Creates a time-bound signed URL for private buckets.
  Future<String> createSignedUrl({
    required String bucket,
    required String path,
    required Duration expiresIn,
    TransformOptions? transform,
  });

  /// Removes a single file.
  Future<void> remove({required String bucket, required String path});

  /// Removes multiple files.
  Future<void> removeAll({
    required String bucket,
    required Iterable<String> paths,
  });
}
