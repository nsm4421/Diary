import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/entity/diary_media_asset.dart';
import 'package:diary/presentation/provider/diary/detail/diary_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:diary/core/extension/build_context_extension.dart';

part 's_diary_detail.dart';

part 'f_carousel.dart';

@RoutePage()
class DiaryDetailPage extends StatelessWidget {
  const DiaryDetailPage(this._diaryId, {super.key});

  final String _diaryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<DiaryDetailCubit>(param1: _diaryId)..init(),
      child: BlocBuilder<DiaryDetailCubit, DiaryDetailState>(
        builder: (context, state) {
          if (state.isFetched && state.diary != null) {
            debugPrint('[DiaryDetailPage]show screen');
            return _Screen(state.diary!);
          } else if (state.isLoading) {
            debugPrint('[DiaryDetailPage]loading');
            return Center(child: CircularProgressIndicator());
          } else {
            debugPrint('[DiaryDetailPage]error');
            final message = state.errorMessage;
            return Center(
              child: Text(message, style: context.textTheme.labelLarge),
            );
          }
        },
      ),
    );
  }
}
