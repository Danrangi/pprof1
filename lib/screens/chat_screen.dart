// Import Flutter material package
import 'package:flutter/material.dart';
// Import chat message widget
import '../widgets/chat_message.dart';
// Import input box widget
import '../widgets/input_box.dart';
// Import gemma service (will be implemented in Phase 2)
import '../utils/gemma_service.dart';

// Message model to store chat messages
class Message {
  // Type of message (user or AI)
  final String sender;
  // Content of the message
  final String text;
  // Timestamp when the message was created (used internally)
  final DateTime timestamp;

  // Constructor for creating a message
  Message({required this.sender, required this.text, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

// Main chat screen widget with state
class ChatScreen extends StatefulWidget {
  // Constructor with optional key parameter
  const ChatScreen({Key? key}) : super(key: key);

  // Create the mutable state for this widget
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

// State class for ChatScreen
class _ChatScreenState extends State<ChatScreen> {
  // List to store all messages
  final List<Message> _messages = [];
  // Controller for the text input field
  final TextEditingController _textController = TextEditingController();
  // Scroll controller to manage scrolling behavior
  final ScrollController _scrollController = ScrollController();
  // Boolean to track if AI is currently "thinking"
  bool _isLoading = false;

  // Initialize gemma service (currently a placeholder)
  final gemmaService = GemmaService();

  // Initialize with a welcome message
  @override
  void initState() {
    super.initState();
    // Add an initial message from the AI
    _messages.add(
      Message(
        sender: 'bot',
        text: "Hello! I'm Pocket Professor. How can I help you today?",
        timestamp: DateTime.now(),
      ),
    );
  }

  // Clean up controllers when widget is removed
  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll to the bottom of the chat
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Handle sending a message
  void _handleSubmitted(String text) async {
    // Don't process empty messages
    if (text.trim().isEmpty) return;

    // Clear the input field
    _textController.clear();

    // Create and add user message
    final userMessage = Message(sender: 'user', text: text);

    // Update UI with new message
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    // Scroll to show the new message
    _scrollToBottom();

    // PHASE 1: Use dummy response with typing indicator
    // In Phase 2, this will call the actual Gemma LLM
    await Future.delayed(const Duration(seconds: 1));

    // Create bot response
    final botMessage = Message(
      sender: 'bot',
      text:
          "This is a placeholder response. In the future, I'll use the Gemma LLM to generate intelligent responses.",
    );

    // Update UI with bot message
    if (mounted) {
      setState(() {
        _messages.add(botMessage);
        _isLoading = false;
      });
      // Scroll to show the response
      _scrollToBottom();
    }
  }

  // Build the UI for this screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top app bar styled like WhatsApp/ChatGPT
      appBar: AppBar(
        title: Row(
          children: [
            // AI Avatar - circular image
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 16,
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            // App title
            const Text('PProf AI'),
          ],
        ),
        elevation: 1,
        // No three-dot menu
      ),
      // Chat background with subtle pattern
      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFECE5DD)
              : const Color(0xFF121B22),
      // Main body with chat messages
      body: Column(
        children: [
          // Chat message list - takes most of the screen
          Expanded(
            child: Container(
              // Optional background pattern
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFFECE5DD)
                        : const Color(0xFF121B22),
                image: DecorationImage(
                  image: AssetImage(
                    Theme.of(context).brightness == Brightness.light
                        ? 'assets/images/chat_bg_light.png'
                        : 'assets/images/chat_bg_dark.png',
                  ),
                  repeat: ImageRepeat.repeat,
                  opacity: 0.2,
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatMessage(
                    text: message.text,
                    isUser: message.sender == 'user',
                    showAvatar: message.sender == 'bot',
                  );
                },
              ),
            ),
          ),

          // Typing indicator when AI is "thinking"
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  // AI avatar for typing indicator
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 12,
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Animated typing dots
                  const SizedBox(
                    width: 40,
                    child: Row(
                      children: [
                        _TypingDot(delay: Duration(milliseconds: 0)),
                        _TypingDot(delay: Duration(milliseconds: 300)),
                        _TypingDot(delay: Duration(milliseconds: 600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Input area at the bottom
          InputBox(controller: _textController, onSubmitted: _handleSubmitted),
        ],
      ),
    );
  }
}

// Animated typing indicator dot
class _TypingDot extends StatefulWidget {
  final Duration delay;

  const _TypingDot({required this.delay});

  @override
  _TypingDotState createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
      setState(() {});
    });

    Future.delayed(widget.delay, () {
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: 8 + (_animation.value * 4),
        width: 8 + (_animation.value * 4),
        decoration: BoxDecoration(
          color: Colors.grey[600],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
