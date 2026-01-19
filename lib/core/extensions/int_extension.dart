extension IntExtension on int {
  Duration get durationInMilliSec => Duration(milliseconds: this);

  Duration get durationInSec => Duration(seconds: this);
}
