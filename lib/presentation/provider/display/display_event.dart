part of 'display_bloc.dart';

// E : Entity, P : param type
@freezed
class DisplayEvent<E, P> with _$DisplayEvent<E, P> {
  const factory DisplayEvent.started([P? param]) = _Started<E, P>;

  const factory DisplayEvent.refreshed([P? param]) = _Refreshed<E, P>;

  const factory DisplayEvent.nextPageRequested([P? param]) = _NextPageRequested<E, P>;

  const factory DisplayEvent.upserted(E item) = _Upserted<E, P>;

  const factory DisplayEvent.removed(String id) = _Removed<E, P>;
}
