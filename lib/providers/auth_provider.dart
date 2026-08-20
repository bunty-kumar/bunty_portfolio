import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoggedInDemo = false;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isAuthenticated => _user != null || _isLoggedInDemo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _listenToAuth();
  }

  void _listenToAuth() {
    if (FirebaseService.isInitialized) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (FirebaseService.isInitialized) {
        final credential = await FirebaseService.loginAdmin(email.trim(), password);
        _user = credential?.user;
        _isLoggedInDemo = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Fallback demo authentication for instant out-of-the-box testing
        if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
          _isLoggedInDemo = true;
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = "Please enter valid email and password";
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Authentication failed";
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerAdmin(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (FirebaseService.isInitialized) {
        final credential = await FirebaseService.registerAdminUser(email.trim(), password);
        _user = credential?.user;
        _isLoggedInDemo = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoggedInDemo = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Registration failed";
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    if (FirebaseService.isInitialized) {
      await FirebaseService.logoutAdmin();
    }
    _user = null;
    _isLoggedInDemo = false;
    notifyListeners();
  }
}
