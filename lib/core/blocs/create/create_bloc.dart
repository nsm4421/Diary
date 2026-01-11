import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../value_objects/failure.dart';

part 'create_state.dart';

part 'create_event.dart';

part 'create_bloc.freezed.dart';

/// T : data, S : on success return data
abstract class CreateBloc<T, S> extends Bloc<CreateEvent<T>, CreateState<T>> {
  final T initData;

  CreateBloc(this.initData) : super(CreateState<T>.editing(initData)) {
    on<_Update<T>>(_onUpdate, transformer: droppable());
    on<_Reset<T>>(_onReset, transformer: droppable());
    on<_Submit<T>>(_onSubmit, transformer: droppable());
  }

  @protected
  TaskEither<Failure, S> submit(T data);

  @protected
  void onSuccess(S res);

  @protected
  String? validate(T data);

  Future<void> _onUpdate(_Update<T> event, Emitter<CreateState<T>> emit) async {
    if (state.canEditable) {
      emit(_Editing(event.data));
    }
  }

  Future<void> _onReset(_Reset<T> event, Emitter<CreateState<T>> emit) async {
    emit(_Editing(state.data));
  }

  Future<void> _onSubmit(_Submit<T> event, Emitter<CreateState<T>> emit) async {
    if (state.isLoading) return;

    final errorMessage = validate(state.data);
    if (errorMessage != null) {
      emit(
        _Failure(
          data: state.data,
          failure: Failure(message: errorMessage),
        ),
      );
      return;
    }

    emit(_Submitting(state.data));
    (await submit(state.data).run()).match(
      (failure) {
        emit(_Failure(data: state.data, failure: failure));
      },
      (S res) {
        onSuccess(res);
        emit(_Success(state.data));
      },
    );
  }
}
