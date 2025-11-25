part of 'p_settings.dart';

class _PermissionTile extends StatefulWidget {
  const _PermissionTile();

  @override
  State<_PermissionTile> createState() => _PermissionTileState();
}

class _PermissionTileState extends State<_PermissionTile> {
  String _subtitle(PermissionState state) {
    if (state.isGranted) {
      return '갤러리에서 사진을 불러올 수 있어요.';
    }
    if (state.isBlocked) {
      return '권한이 차단되었어요. 설정에서 허용해주세요.';
    }
    return '일기에 사진을 첨부하려면 접근 권한이 필요해요.';
  }

  String _statusLabel(PermissionState state) {
    if (state.isGranted) return '허용됨';
    if (state.isBlocked) return '설정 필요';
    return '허용 안 됨';
  }

  Color _statusColor(ColorScheme colorScheme, PermissionState state) {
    if (state.isGranted) return colorScheme.primary;
    if (state.isBlocked) return colorScheme.error;
    return colorScheme.onSurfaceVariant;
  }

  void _handleToggle(PermissionState state, bool enable) {
    final cubit = context.read<PermissionCubit>();
    if (state.isLoading) return;

    if (enable) {
      cubit.requestPermission();
    } else {
      cubit.openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return BlocConsumer<PermissionCubit, PermissionState>(
      listenWhen: (prev, curr) =>
          prev.isGranted != curr.isGranted ||
          prev.isBlocked != curr.isBlocked ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.errorMessage?.isNotEmpty == true) {
          context.showToast(state.errorMessage!);
          return;
        }
        if (state.isGranted) {
          context.showToast('사진 접근 권한이 허용되었어요.');
        } else if (state.isBlocked) {
          context.showToast('설정에서 사진 권한을 허용해주세요.');
        }
      },
      builder: (context, state) {
        final statusColor = _statusColor(colorScheme, state);
        return _SettingTile(
          icon: Icons.photo_outlined,
          title: '사진 접근 권한',
          subtitle: _subtitle(state),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _statusLabel(state),
                      style: textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: state.isGranted,
                    onChanged: state.isLoading
                        ? null
                        : (enable) => _handleToggle(state, enable),
                  ),
                ],
              ),
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: SizedBox(
                    height: 2,
                    width: 40,
                    child: LinearProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
