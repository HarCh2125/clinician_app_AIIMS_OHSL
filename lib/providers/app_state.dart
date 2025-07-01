import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool? _isNewPatient;
  String? _currentPatientId;

  bool get isLoggedIn => _isLoggedIn;
  bool? get isNewPatient => _isNewPatient;
  String? get currentPatientId => _currentPatientId;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _isNewPatient = null;
    _currentPatientId = null;
    notifyListeners();
  }

  void selectNewPatient(bool? isNew) {
    _isNewPatient = isNew;
    notifyListeners();
  }

  void setCurrentPatient(String id) {
    _currentPatientId = id;
    notifyListeners();
  }
}
