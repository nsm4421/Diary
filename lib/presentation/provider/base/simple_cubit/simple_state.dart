part of 'simple_cubit.dart';

@CopyWith(copyWithNull: true)
class SimpleState {
  final Status status;
  final String? errorMessage;

  SimpleState({this.status = Status.initial, this.errorMessage});
}
