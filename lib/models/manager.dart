//model cassier from 1c
class AppData {
  static final AppData _appManager = AppData._internal();
  static Manager? manager;
  factory AppData() {
    return _appManager;
  }
  AppData._internal();
}

class Manager {
  String ref = '';
  String name = '';
  String cassierKey = '';
  bool isFired = true;
}
