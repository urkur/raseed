import 'package:flutter/material.dart';
import 'package:raseed/screens/chat_screen.dart';

class ChatWidget extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ChatWidget({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      },
      child: const Icon(Icons.chat),
    );
  }
}
