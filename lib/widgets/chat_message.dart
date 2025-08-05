// Import Flutter material package
import 'package:flutter/material.dart';

// Reusable widget for displaying chat messages
class ChatMessage extends StatelessWidget {
  // Text content of the message
  final String text;
  // Flag to determine if message is from user (true) or AI (false)
  final bool isUser;
  // Whether to show an avatar (typically for AI messages)
  final bool showAvatar;

  // Constructor requiring text and isUser flag
  const ChatMessage({
    Key? key,
    required this.text,
    required this.isUser,
    this.showAvatar = false,
  }) : super(key: key);

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

    // Padding insets for the message row
    final padding =
        isUser
            ? const EdgeInsets.only(
              left: 60.0,
              right: 8.0,
              top: 4.0,
              bottom: 4.0,
            )
            : const EdgeInsets.only(
              left: 8.0,
              right: 60.0,
              top: 4.0,
              bottom: 4.0,
            );

    return Padding(
      // Apply padding to create space around the message
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Show avatar for AI messages if enabled
          if (showAvatar && !isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                radius: 16,
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),

          // Message bubble with content
          Flexible(
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                // Message bubble with tail
                CustomPaint(
                  painter: BubblePainter(color: bgColor, isUser: isUser),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Text(text, style: TextStyle(color: textColor)),
                  ),
                ),
              ],
            ),
          ),

          // Show check marks for user messages (WhatsApp style)
          if (isUser)
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Icon(
                Icons.done_all,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

// Custom painter for chat bubbles with tails
class BubblePainter extends CustomPainter {
  final Color color;
  final bool isUser;

  BubblePainter({required this.color, required this.isUser});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();

    if (isUser) {
      // User message bubble with tail on right
      path.moveTo(size.width - 10, size.height / 2);
      path.lineTo(size.width, size.height / 2 - 10);
      path.lineTo(size.width, size.height / 2 + 10);
      path.close();

      // Main bubble
      final RRect bubble = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width - 10, size.height),
        const Radius.circular(16),
      );
      canvas.drawRRect(bubble, paint);
    } else {
      // AI message bubble with tail on left
      path.moveTo(10, size.height / 2);
      path.lineTo(0, size.height / 2 - 10);
      path.lineTo(0, size.height / 2 + 10);
      path.close();

      // Main bubble
      final RRect bubble = RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 0, size.width - 10, size.height),
        const Radius.circular(16),
      );
      canvas.drawRRect(bubble, paint);
    }

    // Draw the tail
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
