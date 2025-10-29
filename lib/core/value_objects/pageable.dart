class Pageable<T, C> {
  final List<T> items;
  final C? nextCursor;
  final int? total;

  const Pageable({this.items = const [], this.nextCursor, this.total});

  factory Pageable.empty([int? total]) {
    return Pageable<T, C>(total: total);
  }

  factory Pageable.from(List<T> items) {
    return Pageable<T, C>(items: items);
  }

  Pageable<T, C> copyWithNextCursor(C? nextCursor) {
    return Pageable<T, C>(items: items, nextCursor: nextCursor, total: total);
  }
}
