import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class AuthRepository {
  static const _tokenKey = 'auth_token';
  final _storage = const FlutterSecureStorage();

  String _hash(String input) => sha256.convert(utf8.encode(input)).toString();

  Future<bool> login(String username, String password) async {
    final raw = await rootBundle.loadString('asset/users.json'); // match your path
    final users = (jsonDecode(raw)['users'] as List);
    final match = users.any((u) =>
        u['username'] == username.trim() && u['passwordHash'] == _hash(password));
    if (!match) return false;
    await _storage.write(key: _tokenKey, value: const Uuid().v4());
    return true;
  }

  Future<bool> hasSession() async =>
      (await _storage.read(key: _tokenKey)) != null;

  Future<void> logout() => _storage.delete(key: _tokenKey);
}