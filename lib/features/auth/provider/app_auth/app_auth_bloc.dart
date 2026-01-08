import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/auth_failure.dart';
import '../../service/auth_service.dart';
import '../../model/auth_user_model.dart';

part 'app_auth_state.dart';

part 'app_auth_event.dart';

part 'app_auth_bloc.freezed.dart';

class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  final AuthService _authService;
  late final StreamSubscription<AuthUserModel?> _authStreamSubscription;

  AppAuthBloc(this._authService) : super(AppAuthState.idle()) {
    on<_signOutEvent>(_onSignOut);
    on<_authenticatedEvent>(_onAuthenticated);
    on<_unAuthenticatedEvent>(_onUnAuthenticated);
    _authStreamSubscription = _authService.authUserStream.listen((e) {
      add(e == null ? _unAuthenticatedEvent() : _authenticatedEvent(e));
    });
  }

  Future<void> _onSignOut(
    _signOutEvent event,
    Emitter<AppAuthState> emit,
  ) async {
    (await _authService.signOut().run()).match(
      (failure) {
        emit(_UnAuthenticatedState());
      },
      (_) {
        emit(_UnAuthenticatedState());
      },
    );
  }

  Future<void> _onAuthenticated(
    _authenticatedEvent event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(_AuthenticatedState(event.authUser));
  }

  Future<void> _onUnAuthenticated(
    _unAuthenticatedEvent event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(_UnAuthenticatedState());
  }

  @override
  Future<void> close() {
    _authStreamSubscription.cancel();
    return super.close();
  }
}
