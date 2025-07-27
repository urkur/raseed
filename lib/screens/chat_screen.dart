
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raseed/constants.dart';
import 'package:raseed/models/chat_model.dart';
import 'package:raseed/providers/chat_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _user = const types.User(id: 'user');
  final _bot = const types.User(id: 'bot', firstName: 'Raseed');

  @override
  void initState() {
    super.initState();
    // Reset chat history when the screen is initialized
    Future.microtask(() => ref.refresh(chatProvider));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    ref.read(chatProvider.notifier).addMessage(textMessage);

    // Add a "typing" indicator
    ref.read(chatProvider.notifier).addMessage(
      types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: '...',
      ),
    );

    _getBotResponse(message.text);
  }

  Future<void> _getBotResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.chatUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "text": message,
          "files": [],
          "session_id": "test_session_123",
          "user_id": "test_user_456"
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final botMessage = types.TextMessage(
          author: _bot,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: responseData['response'],
        );
        ref.read(chatProvider.notifier).addMessage(botMessage);
      } else {
        _handleError();
      }
    } catch (e) {
      _handleError();
    } finally {
      // Remove the "typing" indicator
      ref.read(chatProvider.notifier).removeTyping();
    }
  }

  void _handleError() {
    final errorMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: 'Sorry, something went wrong.',
    );
    ref.read(chatProvider.notifier).addMessage(errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raseed Assistance'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Chat(
        messages: messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: DefaultChatTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          primaryColor: Theme.of(context).primaryColor,
          secondaryColor: Theme.of(context).colorScheme.secondary,
          inputBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          inputTextColor: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
        inputOptions: const InputOptions(
          autofocus: true,
        ),
      ),
    );
  }
}
