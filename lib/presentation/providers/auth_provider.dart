import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;
  String? _userName;
  String? _authToken;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get authToken => _authToken;
  
  Future<bool> login(String email, String password) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock login success
      _isAuthenticated = true;
      _userId = '12345';
      _userEmail = email;
      _userName = 'User Name';
      _authToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> signup(String email, String password, String name) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock signup success
      _isAuthenticated = true;
      _userId = '12345';
      _userEmail = email;
      _userName = name;
      _authToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> logout() async {
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    _userName = null;
    _authToken = null;
    
    notifyListeners();
  }
  
  Future<bool> checkAuthStatus() async {
    // TODO: Check if stored token is valid
    await Future.delayed(const Duration(milliseconds: 500));
    return _isAuthenticated;
  }
}