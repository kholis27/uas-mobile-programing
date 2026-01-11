import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import '../widgets/app_logo_3d.dart';
import '../services/session_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(seconds: 2));
    final loggedIn = await SessionService.isLoggedIn();
    if (!mounted) return;

    if (loggedIn) {
      final username = await SessionService.getUsername();
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => HomeScreen(username: username ?? 'User')),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppBackground(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogo3D(size: 110),
                SizedBox(height: 16),
                Text(
                  'Notes CRUD App',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'SQLite • List/Grid • CRUD',
                  style: TextStyle(
                      color: Color(0xEEFFFFFF), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 22),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
