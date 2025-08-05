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
  const PProfApp({Key? key}) : super(key: key);

  // Build method defines the widget tree for this component
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application title shown in task switchers
      title: 'PProf',
      // Remove the debug banner in the upper right corner
      debugShowCheckedModeBanner: false,
      // Light theme configuration
      theme: ThemeData(
        // Generate a color scheme based on a seed color
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        // Enable Material 3 design system
        useMaterial3: true,
      ),
      // Dark theme configuration for better night viewing
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
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
