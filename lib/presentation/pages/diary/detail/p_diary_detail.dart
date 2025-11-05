import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/entity/diary_media_asset.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 's_diary_detail.dart';

part 'f_carousel.dart';

@RoutePage()
class DiaryDetailPage extends StatefulWidget {
  const DiaryDetailPage(this._diaryId, {super.key});

  final String _diaryId;

  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  DiaryDetailEntity? _diary;
  late bool _isLoading;
  Failure? _failure;

  @override
  initState() {
    super.initState();
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _handleInit();
    });
  }

  _handleInit() async {
    await GetIt.instance<DiaryUseCases>().getDetail
        .call(widget._diaryId)
        .then(
          (res) => res.fold(
            (l) {
              _failure = l;
            },
            (r) {
              _diary = r;
            },
          ),
        )
        .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_failure != null || _diary == null) {
      return Center(
        child: Text(
          _failure?.message ?? 'ERROR',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
    }
    return _Screen(_diary!);
  }
}
