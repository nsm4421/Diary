part of 'sign_in_cubit.dart';

typedef SignInInput = ({String email, String password});

@freezed
sealed class SignInState with _$SignInState {
  factory SignInState.editing(SignInInput input) = _EditingState;

  factory SignInState.loading(SignInInput input) = _LoadingState;

  factory SignInState.success(AuthUserModel authUser) = _SuccessState;

  factory SignInState.failure({
    required SignInInput input,
    required Failure failure,
  }) = _FailureState;
}

extension SignInStateExtension on SignInState {
  bool get isLoading => maybeWhen(loading: (_) => true, orElse: () => false);

  bool get isEditing => maybeWhen(editing: (_) => true, orElse: () => false);

  bool get canRequest => maybeWhen(editing: (_) => true, orElse: () => false);

  bool get isError => maybeWhen(failure: (_, _) => true, orElse: () => false);
}
