part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class LoadChat extends ChatEvent {}

final class SendMessage extends ChatEvent {
  final String message;

  SendMessage({
    required this.message,
  });

  @override
  String toString() => 'SendMessage { message: $message }';
}