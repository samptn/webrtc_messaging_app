part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class LoadChat extends ChatEvent {
  final String roomId;

  LoadChat({
    required this.roomId,
  });

  @override
  String toString() => 'LoadChat { roomId: $roomId }';
}

final class SendMessage extends ChatEvent {
  final String message;
  final String roomId; 

  SendMessage({
    required this.message,
    required this.roomId, 
  });

  @override
  String toString() => 'SendMessage { message: $message }';
}