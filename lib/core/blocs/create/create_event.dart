part of 'create_bloc.dart';

@freezed
abstract class CreateEvent<T> with _$CreateEvent<T> {
  const factory CreateEvent.update(T data) = _Update<T>;

  const factory CreateEvent.reset() = _Reset<T>;

  const factory CreateEvent.submit() = _Submit<T>;
}
