enum Status { initial, loading, success, error }

extension StatusExtension on Status {
  bool get isInitial => switch (this) {
    Status.initial => true,
    (_) => false,
  };

  bool get isLoading => switch (this) {
    Status.loading => true,
    (_) => false,
  };

  bool get isSuccess => switch (this) {
    Status.success => true,
    (_) => false,
  };

  bool get isError => switch (this) {
    Status.error => true,
    (_) => false,
  };
}
