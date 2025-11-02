class ResizeOption {
  final int? width;
  final int? height;
  final bool maintainAspectRatio;
  final StorageImageFormat? format;
  final int quality;

  const ResizeOption({
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.format,
    this.quality = 85,
  }) : assert(width != null || height != null, 'Either width or height must be provided.');
}

enum StorageImageFormat { jpeg, png, webp }