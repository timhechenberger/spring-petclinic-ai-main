import 'package:flutter/material.dart';

import '../../widgets/chat_bubble.dart';
import '../../widgets/chat_input.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  static const Color _primaryGreen = Color(0xFF3F7F4C);

  final List<_ChatMessage> _messages = <_ChatMessage>[
    _ChatMessage(
      text: 'Hi! Stell deine Frage zu unserer Pet Clinic!',
      role: _ChatRole.assistant,
      createdAt: DateTime.now(),
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage() async {
    final raw = _textController.text;
    final text = raw.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
      _messages.add(_ChatMessage(
        text: text,
        role: _ChatRole.user,
        createdAt: DateTime.now(),
      ));
      _textController.clear();
    });

    _scrollToBottom();

    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: 'Statische Antwort',
        role: _ChatRole.assistant,
        createdAt: DateTime.now(),
      ));
      _isSending = false;
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 10),
            child: Text(
              'Support',
              style: const TextStyle(
                color: _primaryGreen,
                fontSize: 44,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
          ),

          // Chatbereich
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 10,
                      bottom: 18,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final m = _messages[index];
                      return ChatBubble(
                        text: m.text,
                        isUser: m.role == _ChatRole.user,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Input unten (über der Navbar)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
            child: ChatInput(
              controller: _textController,
              enabled: !_isSending,
              hintText: 'Unsere KI fragen...',
              onSend: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

enum _ChatRole { user, assistant }

class _ChatMessage {
  final String text;
  final _ChatRole role;
  final DateTime createdAt;

  _ChatMessage({
    required this.text,
    required this.role,
    required this.createdAt,
  });
}
