class Room {
  final String roomId;
  final String name;
  final String? creatorId;

  Room({
    required this.roomId,
    required this.name,
    this.creatorId,
  });
  
}