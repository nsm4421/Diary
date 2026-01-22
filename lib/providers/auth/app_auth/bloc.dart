import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:auth/auth.dart';
import 'package:logger/logger.dart';
import 'package:shared/shared.dart';

part 'state.dart';

part 'event.dart';

part 'bloc.freezed.dart';

@lazySingleton
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService _authService;
  final Logger _logger;
  StreamSubscription<AuthUserModel?>? _authStreamSubscription;

  AuthenticationBloc(this._authService, this._logger)
    : super(AuthenticationState.idle()) {
    on<_StartEvent>(_onStart);
    on<_SignOutEvent>(_onSignOut, transformer: restartable());
    on<_OnAuthenticatedEvent>(_onAuthenticated, transformer: restartable());
    on<_OnUnAuthenticatedEvent>(_onUnAuthenticated, transformer: restartable());
  }

  Future<bool> resolveIsAuth() async {
    return state.isIdle
        ? await stream
              .firstWhere((state) => !state.isIdle)
              .then((state) => state.isAuth)
        : state.isAuth;
  }

  Future<void> _onStart(
    _StartEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    (await _authService.getAuthUserStream().run()).match(
      (failure) {
        _logger.f(failure);
        emit(_IdleState());
      },
      (authStream) {
        _authStreamSubscription = authStream.listen((e) {
          add(e == null ? _OnUnAuthenticatedEvent() : _OnAuthenticatedEvent(e));
        });
      },
    );
  }

  Future<void> _onSignOut(
    _SignOutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    (await _authService.signOut().run()).match(
      (failure) {
        _logger.f(failure);
        emit(_UnAuthenticatedState());
      },
      (_) {
        emit(_UnAuthenticatedState());
      },
    );
  }

  Future<void> _onAuthenticated(
    _OnAuthenticatedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(_AuthenticatedState(event.authUser));
    } catch (error, stackTrace) {
      emit(
        _AuthenticatedState(
          event.authUser,
          failure: Failure(
            message: 'unknown error occurs on bloc',
            error: error,
            stackTrace: stackTrace,
          ),
        ),
      );
    }
  }

  Future<void> _onUnAuthenticated(
    _OnUnAuthenticatedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(_UnAuthenticatedState());
    } catch (error, stackTrace) {
      emit(
        _UnAuthenticatedState(
          failure: Failure(
            message: 'unknown error occurs on bloc',
            error: error,
            stackTrace: stackTrace,
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _authStreamSubscription?.cancel();
    return super.close();
  }
}
