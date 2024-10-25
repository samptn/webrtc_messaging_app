import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/room.dart';

abstract class IRoomService {
  Future<List<Room>> getRooms();
}

class RoomService extends IRoomService {
  final _roomRef = FirebaseFirestore.instance.collection("userRooms");
  @override
  Future<List<Room>> getRooms() async {
    QuerySnapshot querySnapshot = await _roomRef.get();

    var temp = querySnapshot.docs.map((e) {
      var room =Room.fromJson(e.data() as Map<String, dynamic>);
      room.roomId=e.id;
      return room;
    }).toList();

    return temp;
  }

  Future<void> createRoom(String roomId, String name, String creatorId) async {
    await _roomRef.doc(roomId).set({
      'roomId': roomId,
      'name': name,
      'creatorId': creatorId,
    });
  }

  Future<void> joinRoom(String roomId, String userId) async {
    await _roomRef.doc(roomId).collection('users').doc(userId).set({
      'userId': userId,
    });
  }

  Future<void> leaveRoom(String roomId, String userId) async {
    await _roomRef.doc(roomId).collection('users').doc(userId).delete();
  }

  Future<void> deleteRoom(String roomId) async {
    await _roomRef.doc(roomId).delete();
  }

  Future<List<String>> getUsersInRoom(String roomId) async {
    QuerySnapshot querySnapshot =
        await _roomRef.doc(roomId).collection('users').get();
    List<String> users = [];
    for (var doc in querySnapshot.docs) {
      users.add(doc.id);
    }
    return users;
  }

  Future<Room?> getRoomById(String roomId) async {
    DocumentSnapshot documentSnapshot = await _roomRef.doc(roomId).get();
    if (documentSnapshot.exists) {
      return Room.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    }
    return null;
  }
}
