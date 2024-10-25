import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable(explicitToJson: true)
class Room {
  String roomId;
  String name;
  final String? creatorId;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  Room({
    required this.roomId,
    required this.name,
    this.creatorId,
  });
}

//command 
//flutter pub run build_runner build --delete-conflicting-outputs --no-deps --no-pub
//flutter pub run build_runner watch --delete-conflicting-outputs --no-deps --no-pub