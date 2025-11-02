import 'dart:math' as math;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

import '../value_objects/storage.dart';

@lazySingleton
mixin class ImageUtilMixIn {
  Future<Uint8List> tryResize({
    required Uint8List bytes,
    required ResizeOption resize,
    required String targetExtension,
  }) async {
    final source = img.decodeImage(bytes);
    if (source == null) {
      return bytes;
    }
    final dims = _resolveDimensions(source, resize);
    final resized = img.copyResize(
      source,
      width: dims.width,
      height: dims.height,
      interpolation: img.Interpolation.linear,
    );
    final format =
        resize.format ??
        switch (targetExtension) {
          '.png' => StorageImageFormat.png,
          '.webp' => StorageImageFormat.webp,
          (_) => StorageImageFormat.jpeg,
        };
    final quality = resize.quality.clamp(1, 100).toInt();
    final encodedBytes = switch (format) {
      StorageImageFormat.png => img.encodePng(resized),
      StorageImageFormat.webp => img.encodeJpg(resized, quality: quality),
      StorageImageFormat.jpeg => img.encodeJpg(resized, quality: quality),
    };
    return Uint8List.fromList(encodedBytes);
  }

  ({int width, int height}) _resolveDimensions(
    img.Image source,
    ResizeOption option,
  ) {
    final originalWidth = source.width;
    final originalHeight = source.height;

    int? targetWidth = option.width;
    int? targetHeight = option.height;

    if (option.maintainAspectRatio) {
      final double aspect = originalWidth / originalHeight;
      if (targetWidth != null && targetHeight != null) {
        final widthRatio = targetWidth / originalWidth;
        final heightRatio = targetHeight / originalHeight;
        final ratio = math.min(widthRatio, heightRatio);
        targetWidth = math.max(1, (originalWidth * ratio).round());
        targetHeight = math.max(1, (originalHeight * ratio).round());
      } else if (targetWidth != null) {
        targetHeight = math.max(1, (targetWidth / aspect).round());
      } else if (targetHeight != null) {
        targetWidth = math.max(1, (targetHeight * aspect).round());
      }
    }

    targetWidth ??= option.width ?? originalWidth;
    targetHeight ??= option.height ?? originalHeight;

    if (targetWidth <= 0 || targetHeight <= 0) {
      return (width: originalWidth, height: originalHeight);
    }

    return (width: targetWidth, height: targetHeight);
  }
}
