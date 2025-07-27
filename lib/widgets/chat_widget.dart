import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const ChatWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.chat),
      ),
    );
  }
}