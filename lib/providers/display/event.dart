part of 'bloc.dart';

abstract class DisplayEvent {
  const DisplayEvent();
}

class DisplayRefreshEvent extends DisplayEvent {
  const DisplayRefreshEvent();
}

class DisplayFetchMoreEvent extends DisplayEvent {
  const DisplayFetchMoreEvent();
}
