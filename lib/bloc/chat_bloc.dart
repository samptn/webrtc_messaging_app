import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '/service/message_service.dart';

import '../models/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _currentUser = FirebaseAuth.instance.currentUser;

  ChatBloc() : super(ChatInitial()) {
    on<LoadChat>(_loadChat);
    on<SendMessage>(_sendMessage);
  }

  Future<void> _loadChat(LoadChat event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    final temp = await MessageService().getMessages(event.roomId);

    temp.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
    final messages = [...temp];
    emit(ChatLoaded(messages: messages));
  }

  Future<void> _sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    final state = this.state as ChatLoaded;
    final newMessage = Message(
      senderId: _currentUser?.uid,
      text: event.message,
      roomId: event.roomId,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, newMessage];

    MessageService().sendMessage(newMessage, "${_currentUser?.uid}");
    emit(state.copyWith(messages: updatedMessages));
  }
}
