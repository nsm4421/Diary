import 'package:logger/logger.dart';

class MockLogger extends Logger {
  MockLogger() : super(level: Level.nothing);

  final List<LogEvent> events = [];

  @override
  void log(
    Level level,
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    events.add(
      LogEvent(
        level,
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }
}
