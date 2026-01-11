import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../value_objects/failure.dart';

part 'get_data_state.dart';

part 'get_data_cubit.freezed.dart';

abstract class GetDataCubit<T> extends Cubit<GetDataState<T>> {
  GetDataCubit() : super(_Idle<T>());

  @protected
  TaskEither<Failure, T> callApi(String id);

  Future<void> fetch(String id) async {
    (await callApi(id).run()).match(
      (failure) => emit(_Failure(failure)),
      (data) => emit(_Success(data)),
    );
  }
}
