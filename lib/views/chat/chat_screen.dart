import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '/models/message.dart';
import '/routes/app_routes.dart';

import '../../bloc/chat_bloc.dart';

void kPrint(Object? data) {
  if (kDebugMode) {
    print(data);
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatBloc = ChatBloc();
  final messageController = TextEditingController();
  final _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var queryParams = GoRouterState.of(context).uri.queryParameters;
    _chatBloc.add(LoadChat(roomId: '${queryParams['roomId']}'));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${queryParams['roomId']}",
        ),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
              "https://picsum.photos/200/300?random=10",
            ),
            backgroundColor: Colors.deepPurple,
          ),
        ),
        actions: [
          //call button
          IconButton(
            onPressed: () {
              kPrint("Call button pressed");
              context.goNamed(
                AppRoutes.callingNamed,
                queryParameters: {
                  'roomId': queryParams['roomId'],
                },
              );
            },
            icon: const Icon(Icons.call),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              bloc: _chatBloc,
              builder: (context, state) {
                if (state is ChatLoaded) {
                  var messages = state.messages;
                  return ListView(
                    children: [
                      ...List.generate(
                        messages.length,
                        (index) {
                          var isMe =
                              messages[index].senderId == _currentUser?.uid;
                          return ChatBubbleWidget(
                            message: messages[index],
                            isMe: isMe,
                          );
                        },
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MessageBox(
              onTapSend: (text) {
                if (text == null) {
                  return;
                }
                if (text.trim().isEmpty) {
                  return;
                }
                _chatBloc.add(SendMessage(
                    message: text, roomId: '${queryParams['roomId']}'));
                messageController.clear();
              },
              controller: messageController,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubbleWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: isMe ? 32 : 16,
        right: isMe ? 16 : 32,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            const CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(
                "https://picsum.photos/200/300?random=10",
              ),
            ),
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.deepPurple : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(0),
                      bottomRight: isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    message.text ?? "",
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                // const SizedBox(height: 4),
                // Container(
                //   // color: Colors.red,
                //   alignment:
                //       isMe ? Alignment.centerRight : Alignment.centerLeft,
                //   child: Wrap(
                //     children: [
                //       Image.network(
                //         "https://via.placeholder.com/160",
                //       ),
                //       Image.network(
                //         "https://via.placeholder.com/160",
                //       ),
                //       Image.network(
                //         "https://via.placeholder.com/160",
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 4),
                Text(
                  "${message.timestamp ?? ""}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
          if (isMe)
            const CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(
                "https://picsum.photos/200/300?random=10",
              ),
            ),
        ],
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  final void Function(String? text)? onTapSend;
  final TextEditingController? controller;
  const MessageBox({
    super.key,
    this.onTapSend,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.attach_file,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.image,
            color: Colors.grey,
          ),

          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (value) {
                // Handle text input changes
              },
            ),
          ),

          // Send button
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onTapSend?.call(controller?.text);
            },
            child: const Icon(
              Icons.send,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
