import 'dart:async';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:diary/core/utils/app_logger.dart';
import 'package:diary/domain/entity/auth/auth_user_entity.dart';
import 'package:diary/domain/usecase/auth/auth_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'auth_state.dart';

part 'auth_event.dart';

part 'auth_bloc.g.dart';

part 'auth_bloc.freezed.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases _useCases;
  final Logger _logger;
  late final StreamSubscription<AuthUserEntity?> _authSubscription;

  AuthBloc(this._useCases, this._logger) : super(AuthState()) {
    on<_Initial>(_onInit);
    on<_Update>(_onUpdate);
    on<_SignIn>(_onSignIn);
    on<_SignUp>(_onSignUp);
    on<_SignOut>(_onSignOut);
    _authSubscription = _useCases.authStream.listen(
      (user) => add(AuthEvent.update(user)),
    );
  }

  Future<void> _onInit(_Initial event, Emitter<AuthState> emit) async {
    final user = _useCases.currentUser;
    if (user != null) {
      _logger.t('initial user restored');
      emit(AuthState.authenticated(user));
    } else {
      _logger.t('initial unauthenticated');
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onUpdate(_Update event, Emitter<AuthState> emit) async {
    if (event.user == null) {
      _logger.t('user=null');
      emit(AuthState.unauthenticated());
    } else {
      _logger.t('user updated');
      emit(AuthState.authenticated(event.user!));
    }
  }

  Future<void> _onSignIn(_SignIn event, Emitter<AuthState> emit) async {
    if (state.isAuth) {
      _logger.t('sign in request dropped');
      return;
    }
    try {
      emit(
        state
            .copyWith(status: AuthStatus.loading)
            .copyWithNull(user: true, errorMessage: true),
      );
      await _useCases.signIn
          .call(email: event.email, password: event.password)
          .then(
            (res) => res.mapLeft((l) {
              _logger.fail(l);
              emit(AuthState.error(l.message));
            }),
          );
    } catch (e, st) {
      _logger.e('sign in error', error: e, stackTrace: st);
      emit(AuthState.error('error occurs'));
    }
  }

  Future<void> _onSignUp(_SignUp event, Emitter<AuthState> emit) async {
    if (state.isAuth) {
      _logger.t('sign up request dropped');
      return;
    }
    try {
      emit(
        state
            .copyWith(status: AuthStatus.loading)
            .copyWithNull(user: true, errorMessage: true),
      );
      await _useCases.signUp
          .call(
            email: event.email,
            password: event.password,
            displayName: event.displayName,
            bio: event.bio,
            avatarUrl: event.avatarUrl,
          )
          .then(
            (res) => res.mapLeft((l) {
              _logger.fail(l);
              emit(AuthState.error(l.message));
            }),
          );
    } catch (e, st) {
      _logger.e('sign out error', error: e, stackTrace: st);
      emit(AuthState.error('error occurs'));
    }
  }

  Future<void> _onSignOut(_SignOut event, Emitter<AuthState> emit) async {
    try {
      emit(AuthState.unauthenticated());
    } catch (e, st) {
      _logger.e('sign out error', error: e, stackTrace: st);
      emit(AuthState.error('error occurs'));
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    return super.close();
  }
}
