// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Services
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'services/meditation_service.dart';
import 'services/content_service.dart';
import 'services/calendar_service.dart';
import 'services/power_service.dart';
import 'services/user_service.dart';
import 'services/subscription_service.dart';
import 'services/networking_service.dart';
import 'services/livestream_service.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/meditation_provider.dart';
import 'providers/content_provider.dart';
import 'providers/calendar_provider.dart';
import 'providers/power_provider.dart';
import 'providers/user_provider.dart';
import 'providers/subscription_provider.dart';
import 'providers/networking_provider.dart';
import 'providers/livestream_provider.dart';

import 'shared_background.dart';
import 'intro_sequence_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API client
  final storage = const FlutterSecureStorage();
  final httpClient = http.Client();
  final apiClient = ApiClient(httpClient, storage);
  await apiClient.loadToken();
  
  // Initialize services
  final authService = AuthService(apiClient);
  final meditationService = MeditationService(apiClient);
  final contentService = ContentService(apiClient);
  final calendarService = CalendarService(apiClient);
  final powerService = PowerService(apiClient);
  final userService = UserService(apiClient);
  final subscriptionService = SubscriptionService(apiClient);
  final networkingService = NetworkingService(apiClient);
  final livestreamService = LivestreamService(apiClient);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(create: (_) => MeditationProvider(meditationService)),
        ChangeNotifierProvider(create: (_) => ContentProvider(contentService)),
        ChangeNotifierProvider(create: (_) => CalendarProvider(calendarService)),
        ChangeNotifierProvider(create: (_) => PowerProvider(powerService)),
        ChangeNotifierProvider(create: (_) => UserProvider(userService)),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider(subscriptionService)),
        ChangeNotifierProvider(create: (_) => NetworkingProvider(networkingService)),
        ChangeNotifierProvider(create: (_) => LivestreamProvider(livestreamService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Interactive Font Screen',
      home: InitialLoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  bool _textVisible = false;

  final Map<String, dynamic> _phase = {
    'text': 'Good Evening!',
    'bgColor': '1B0A33',
    'textColor': '7F818C',
  };

  @override
  void initState() {
    super.initState();
    // Fade in the text
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _textVisible = true);
    });

    // Automatically navigate to the sequence screen
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const IntroSequenceScreen(), // <-- GO TO THE NEW SCREEN
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 1500),
          ),
        );
      }
    });
  }
  
  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharedBackground(
        bgColorHex: _phase['bgColor'],
        child: Center(
          child: AnimatedOpacity(
            opacity: _textVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeIn,
            child: Text(
              _phase['text'],
              textAlign: TextAlign.center,
              style: TextStyle(
          fontFamily: 'DMSans',
                color: _hexToColor(_phase['textColor']),
                fontSize: 36,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}