import 'dart:convert';
import 'dart:async';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final token = ''.obs;
  DateTime? _expiryDate;
  final userId = ''.obs;
  Timer? _authTimer;

  bool get isAuth {
    return token.value != '';
  }

  Future<void> _authenticate(
      String email, String password, String segmentUrl) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$segmentUrl?key=AIzaSyBHTvpOmyKl3sdaBTJ_-yYxzUrkM1SGRPc');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }

      token.value = responseData['idToken'];
      userId.value = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token.value,
        'userId': userId.value,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData') ?? '');
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    token.value = extractedUserData['token'];
    userId.value = extractedUserData['userId'];
    _expiryDate = expiryDate;
    _autoLogout();
    return true;
  }

  Future<void> loggout() async {
    token.value = '';
    _expiryDate = null;
    userId.value = '';
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), loggout);
  }
}
