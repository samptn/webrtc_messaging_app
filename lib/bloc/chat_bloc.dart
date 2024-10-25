import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChat>(_loadChat);
    on<SendMessage>(_sendMessage);
  }

  Future<void> _loadChat(LoadChat event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    // TODO: Load chat messages from database or API
    final messages = [
      Message(
        senderId: 'user1',
        message: 'Hello!',
        roomId: 'room1',
        timestamp: DateTime.now(),
      ),
      Message(
        senderId: 'user2',
        message: 'Hi there!',
        roomId: 'room1',
        timestamp: DateTime.now(),
      ),
    ];
    emit(ChatLoaded(messages: messages));
  }

  Future<void> _sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    // TODO: Send message to database or API
    final state = this.state as ChatLoaded;
    final newMessage = Message(
      senderId: 'user1',
      message: event.message,
      roomId: 'room1',
      timestamp: DateTime.now(),
    );
    final updatedMessages = [...state.messages, newMessage];
    emit(state.copyWith(messages: updatedMessages));
  }
}
