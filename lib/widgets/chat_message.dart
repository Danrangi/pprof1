// Import Flutter material package
import 'package:flutter/material.dart';

// Reusable widget for displaying chat messages
class ChatMessage extends StatelessWidget {
  // Text content of the message
  final String text;
  // Flag to determine if message is from user (true) or AI (false)
  final bool isUser;
  // Optional timestamp to display with the message
  final DateTime? timestamp;

  // Constructor requiring text and isUser flag
  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.timestamp,
  });

  // Build the UI for this widget
  @override
  Widget build(BuildContext context) {
    // Get the current theme to use its colors
    final theme = Theme.of(context);

    // Configure colors based on whether it's a user or AI message
    final bgColor =
        isUser
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.secondaryContainer;
    final textColor =
        isUser
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSecondaryContainer;

    // Determine alignment (user messages on right, AI on left)
    final alignment =
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    // Padding insets for the message column
    final padding =
        isUser
            ? const EdgeInsets.only(
              left: 64.0,
              right: 8.0,
              top: 4.0,
              bottom: 4.0,
            )
            : const EdgeInsets.only(
              left: 8.0,
              right: 64.0,
              top: 4.0,
              bottom: 4.0,
            );

    return Padding(
      // Apply padding to create space around the message
      padding: padding,
      child: Column(
        // Align based on sender (user/AI)
        crossAxisAlignment: alignment,
        children: [
          // Message bubble
          Container(
            // Visual styling for the bubble
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Text(
              // Message content
              text,
              style: TextStyle(color: textColor),
            ),
          ),

          // Optional timestamp display
          if (timestamp != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
              child: Text(
                // Format timestamp as hours:minutes
                '${timestamp!.hour}:${timestamp!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
