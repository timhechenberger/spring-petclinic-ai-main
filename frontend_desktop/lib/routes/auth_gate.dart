import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import 'app_router.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isLoggedIn = false;

  void _loginSuccess() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void _logout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return LoginPage(
        onLoginSuccess: _loginSuccess,
      );
    }

    return AdminRouter(
      onLogout: _logout,
    );
  }
}
