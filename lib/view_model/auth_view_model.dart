
import 'package:flutter/foundation.dart';
import 'package:cookie_jar_recipe/data/repository/auth.dart';


class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  AuthViewModel(this._repo);

  bool isLoggedIn = false;
  bool isChecking = true;
  String? error;

  Future<void> init() async {
    isLoggedIn = await _repo.hasSession();
    isChecking = false;
    notifyListeners();
  }

  Future<void> login(String user, String pass) async {
    final ok = await _repo.login(user, pass);
    error = ok ? null : 'Wrong username or password';
    isLoggedIn = ok;
    notifyListeners();
  }

  Future<void> logout() async {
    await _repo.logout();
    isLoggedIn = false;
    notifyListeners();
  }
}