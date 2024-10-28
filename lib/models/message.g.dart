// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      senderId: json['senderId'] as String?,
      text: json['text'] as String?,
      roomId: json['roomId'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'senderId': instance.senderId,
      'text': instance.text,
      'roomId': instance.roomId,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
