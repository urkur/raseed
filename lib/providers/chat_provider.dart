import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

final chatProvider = StateNotifierProvider<ChatNotifier, List<types.Message>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<types.Message>> {
  ChatNotifier() : super([]);

  void addMessage(types.Message message) {
    state = [message, ...state];
  }

  void removeTyping() {
    state = state.where((m) => m.id != 'typing').toList();
  }
}
