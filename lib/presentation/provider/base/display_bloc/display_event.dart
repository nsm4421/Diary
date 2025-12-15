part of 'display_bloc.dart';

// E : Entity
@freezed
class DisplayEvent<E> with _$DisplayEvent<E> {
  const factory DisplayEvent.started() = _Started<E>;

  const factory DisplayEvent.refreshed() = _Refreshed<E>;

  const factory DisplayEvent.nextPageRequested() = _NextPageRequested<E>;

  const factory DisplayEvent.created(E item) = _Created<E>;

  const factory DisplayEvent.update(E item) = _Updated<E>;

  const factory DisplayEvent.removed(String id) = _Removed<E>;
}