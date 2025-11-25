part of 'permission_cubit.dart';


@CopyWith(copyWithNull: true)
class PermissionState extends Equatable {
  const PermissionState({
    this.status = PermissionFlowStatus.idle,
    this.photosStatus = ph.PermissionStatus.denied,
    this.storageStatus = ph.PermissionStatus.denied,
    this.errorMessage,
  });

  final PermissionFlowStatus status;
  final ph.PermissionStatus photosStatus;
  final ph.PermissionStatus storageStatus;
  final String? errorMessage;

  bool get isLoading =>
      status == PermissionFlowStatus.checking ||
      status == PermissionFlowStatus.requesting;

  bool get isGranted =>
      photosStatus.isGranted ||
      photosStatus.isLimited ||
      storageStatus.isGranted;

  bool get isBlocked =>
      photosStatus.isPermanentlyDenied ||
      photosStatus.isRestricted ||
      storageStatus.isPermanentlyDenied;

  bool get isDenied => !isGranted && !isBlocked;

  @override
  List<Object?> get props => [
        status,
        photosStatus,
        storageStatus,
        errorMessage,
      ];
}
