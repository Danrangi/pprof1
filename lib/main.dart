// Import Flutter material package for UI components
import 'package:flutter/material.dart';
// Import the main chat screen
import 'screens/chat_screen.dart';

// Entry point of the application
void main() {
  // Initialize and run the Flutter application
  runApp(const PProfApp());
}

// Root widget of the application, stateless since it doesn't need to manage state
class PProfApp extends StatelessWidget {
  // Constructor with key parameter for widget identification
  const PProfApp({super.key});

  // Build method defines the widget tree for this component
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application title shown in task switchers
      title: 'PProf',
      // Remove the debug banner in the upper right corner
      debugShowCheckedModeBanner: false,
      // Light theme configuration - WhatsApp inspired
      theme: ThemeData(
        // Primary color similar to WhatsApp
        primaryColor: const Color(0xFF075E54),
        // Generate a color scheme based on a teal/green color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF128C7E),
          brightness: Brightness.light,
          // User message bubble color (like WhatsApp)
          primaryContainer: const Color(0xFFDCF8C6),
          onPrimaryContainer: Colors.black87,
          // AI message bubble color (light gray like ChatGPT)
          secondaryContainer: const Color(0xFFEBEBEB),
          onSecondaryContainer: Colors.black87,
        ),
        // App bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF075E54),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        // Enable Material 3 design system
        useMaterial3: true,
      ),
      // Dark theme configuration for better night viewing
      darkTheme: ThemeData(
        primaryColor: Colors.teal[700],
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF128C7E),
          brightness: Brightness.dark,
          // User message bubble color (darker green in dark mode)
          primaryContainer: const Color(0xFF056f5c),
          onPrimaryContainer: Colors.white,
          // AI message bubble color (darker gray in dark mode)
          secondaryContainer: const Color(0xFF2A2A2A),
          onSecondaryContainer: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[900],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      // Use system preference for light/dark theme
      themeMode: ThemeMode.system,
      // Set the initial screen to be displayed
      home: const ChatScreen(),
    );
  }
}
