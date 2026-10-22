import 'package:flutter/material.dart';
import 'contact_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF1F5FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF101827),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF172A46),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),

      themeMode: ThemeMode.dark,

      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: const ContactList(),
    );
  }
}