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
  // Timestamp when the message was created
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

    // PHASE 1: Use dummy response
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
      // Top app bar
      appBar: AppBar(
        title: const Text('PProf AI Chat'),
        elevation: 1,
        centerTitle: true,
      ),
      // Main body with chat messages
      body: Column(
        children: [
          // Chat message list - takes most of the screen
          Expanded(
            child:
                _messages.isEmpty
                    ? const Center(
                      child: Text(
                        'Start a conversation with PProf AI!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return ChatMessage(
                          text: message.text,
                          isUser: message.sender == 'user',
                        );
                      },
                    ),
          ),

          // Loading indicator when AI is "thinking"
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          // Divider between chat and input
          const Divider(height: 1.0),

          // Input area at the bottom
          InputBox(controller: _textController, onSubmitted: _handleSubmitted),
        ],
      ),
    );
  }
}
