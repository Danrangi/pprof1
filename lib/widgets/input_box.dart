// Import Flutter material package
import 'package:flutter/material.dart';

// Widget for handling user text input
class InputBox extends StatelessWidget {
  // Text controller to manage input value
  final TextEditingController controller;
  // Callback function when text is submitted
  final Function(String) onSubmitted;

  // Constructor requiring controller and onSubmitted callback
  const InputBox({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  // Build the UI for this widget
  @override
  Widget build(BuildContext context) {
    return Container(
      // Add padding around the input area
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      // Add decoration to make the input area stand out
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        // Add subtle shadow on top
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3.0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      // Create a row to hold the text field and send button
      child: Row(
        children: [
          // Text input field - expands to fill available width
          Expanded(
            child: TextField(
              // Connect the controller
              controller: controller,
              // Enable multi-line input
              maxLines: null,
              // Text styling
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              // Input field decoration
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 16.0,
                ),
              ),
              // Handle pressing Enter to send (without Shift key)
              onSubmitted: (text) => onSubmitted(text),
              // Capture special key combinations
              onTapOutside: (event) {
                // Remove focus when tapping outside
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          // Send button
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
            // Call the onSubmitted callback with current text
            onPressed: () {
              onSubmitted(controller.text);
            },
          ),
        ],
      ),
    );
  }
}
