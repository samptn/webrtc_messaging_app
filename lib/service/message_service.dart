import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';

abstract class IMessageService {
  Future<void> sendMessage(Message message, String roomId);
  Future<List<Message>> getMessages(String roomId);
}

class MessageService implements IMessageService {
  final _messageRef = FirebaseFirestore.instance.collection("messages");
  @override
  Future<void> sendMessage(Message message, String roomId) async {
    await _messageRef.add(message.toJson());
  }

  @override
  Future<List<Message>> getMessages(String roomId) async {
    QuerySnapshot querySnapshot = await _messageRef
        .where('roomId', isEqualTo: roomId)
        // .orderBy('timestamp', descending: true)
        .get();

    var temp = querySnapshot.docs.map((e) {
      return Message.fromJson(e.data() as Map<String, dynamic>);
    }).toList();

    return temp;
  }
}
