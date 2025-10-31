import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/device_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DeviceService _deviceService = DeviceService();
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFF6F61),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
      backgroundColor: const Color(0xFFFF6F61),
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 160,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
    );
  }

  Future<void> _bootstrap() async {
    // Perform device registration while splash is visible; ignore failures
    try {
      // Give the splash at least ~1.2s for a nicer feel
      await Future.wait([
        _deviceService.registerDevice().catchError((_) {}),
        Future.delayed(const Duration(milliseconds: 3000)),
      ]);
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
  }
}


