import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String? uid;
  final String? email;
  final String? name;
  final String? photoUrl;

  User({
    this.uid,
    this.email,
    this.name,
    this.photoUrl,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
