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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      // Add decoration to make the input area stand out
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF1F2C34),
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
            child: Container(
              // Make the text field look like a rounded input box (WhatsApp style)
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[200]
                    : const Color(0xFF2A3942),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextField(
                // Connect the controller
                controller: controller,
                // Enable multi-line input that expands up to 4 lines
                maxLines: 4,
                minLines: 1,
                // Text styling
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black87
                      : Colors.white,
                ),
                // Input field decoration
                decoration: InputDecoration(
                  hintText: 'Message',
                  hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[600]
                        : Colors.grey[400],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
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
          ),
          
          // Send button - WhatsApp style circular button
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              // Call the onSubmitted callback with current text
              onPressed: () {
                onSubmitted(controller.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}