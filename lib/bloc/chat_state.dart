part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<Message> messages;

  ChatLoaded({
    required this.messages,
  });

  @override
  String toString() => 'ChatLoaded {messages: $messages }';

  //copyWith
  ChatLoaded copyWith({
    List<Message>? messages,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
    );
  }
}
