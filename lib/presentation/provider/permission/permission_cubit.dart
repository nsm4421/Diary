import 'dart:io';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:diary/core/constant/status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:permission_handler/permission_handler.dart';

part 'permission_state.dart';

part 'permission_cubit.g.dart';

@injectable
class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(const PermissionState());

  // 앱 시작시 권한 체크
  Future<void> checkPermission() async {
    emit(
      state.copyWith(status: PermissionFlowStatus.checking, errorMessage: null),
    );

    try {
      final photos = await ph.Permission.photos.status;
      final storage = Platform.isAndroid
          ? await ph.Permission.storage.status
          : ph.PermissionStatus.denied;

      emit(
        state.copyWith(
          status: PermissionFlowStatus.idle,
          photosStatus: photos,
          storageStatus: storage,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PermissionFlowStatus.failure,
          errorMessage: '권한 상태를 확인하지 못했어요. 다시 시도해주세요.',
        ),
      );
    }
  }

  // 권한체크 버튼 눌렀을 때 동작
  Future<void> requestPermission() async {
    emit(
      state.copyWith(
        status: PermissionFlowStatus.requesting,
        errorMessage: null,
      ),
    );

    try {
      final photos = await ph.Permission.photos.request();
      ph.PermissionStatus storage = state.storageStatus;
      if (Platform.isAndroid && !photos.isGranted && !photos.isLimited) {
        storage = await ph.Permission.storage.request();
      }

      final blocked =
          photos.isPermanentlyDenied ||
          photos.isRestricted ||
          storage.isPermanentlyDenied;

      emit(
        state.copyWith(
          status: PermissionFlowStatus.idle,
          photosStatus: photos,
          storageStatus: storage,
          errorMessage: blocked ? '설정에서 사진 접근 권한을 허용해주세요.' : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PermissionFlowStatus.failure,
          errorMessage: '권한을 요청하지 못했어요. 다시 시도해주세요.',
        ),
      );
    }
  }

  // 영구거부일 때
  Future<void> openAppSettings() async {
    emit(
      state.copyWith(
        status: PermissionFlowStatus.requesting,
        errorMessage: null,
      ),
    );

    final opened = await ph.openAppSettings();
    if (!opened) {
      emit(
        state.copyWith(
          status: PermissionFlowStatus.failure,
          errorMessage: '앱 설정을 열 수 없어요. 직접 설정에서 권한을 변경해주세요.',
        ),
      );
      return;
    }
    await checkPermission();
  }
}
