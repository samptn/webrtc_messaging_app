import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(explicitToJson: true)
class Message {
  final String? senderId;
  final String? message;
  final String? roomId;
  final DateTime? timestamp;

  Message({
    this.senderId,
    this.message,
    this.roomId,
    this.timestamp,
  });
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
