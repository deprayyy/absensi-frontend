import 'package:flutter/material.dart';
import 'package:mapss/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:mapss/screens/auth_screen/login_screen.dart';
import 'package:mapss/services/location_service.dart'; // 🔥 import LocationService

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MAPSS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
