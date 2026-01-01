part of 'sign_up_cubit.dart';

typedef SignUpInput = ({String email, String password, String username});

@freezed
sealed class SignUpState with _$SignUpState {
  factory SignUpState.editing(SignUpInput input) = _EditingState;

  factory SignUpState.loading(SignUpInput input) = _LoadingState;

  factory SignUpState.success(AuthUserModel authUser) = _SuccessState;

  factory SignUpState.failure({
    required SignUpInput input,
    required Failure failure,
  }) = _FailureState;
}

extension SignUpStateExtension on SignUpState {
  bool get isLoading => maybeWhen(loading: (_) => true, orElse: () => false);

  bool get isEditing => maybeWhen(editing: (_) => true, orElse: () => false);

  bool get canRequest => maybeWhen(editing: (_) => true, orElse: () => false);

  bool get isError => maybeWhen(failure: (_, _) => true, orElse: () => false);
}
