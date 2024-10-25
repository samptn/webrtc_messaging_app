import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webrtc_messaging_app/routes/app_routes.dart';

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
  @override
  void initState() {
    kPrint("OnInit $widget");
    _chatBloc.add(LoadChat());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var queryParams = GoRouterState.of(context).uri.queryParameters;
    return Scaffold(
      appBar: AppBar(
        title: Text("${queryParams['roomId']}"),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
              "https://eu.ui-avatars.com/api/?name=Sa&size=150",
            ),
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
                return ListView(
                  children: [
                    ...List.generate(
                      testMessages.length,
                      (index) => ChatBubbleWidget(
                        message: testMessages[index].message,
                        isMe: testMessages[index].isMe,
                        time: testMessages[index].time,
                        userImageUrl: testMessages[index].userImageUrl,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: MessageBox(),
          ),
        ],
      ),
    );
  }
}

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String userImageUrl;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
    required this.userImageUrl,
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
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(userImageUrl),
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
                    color: isMe ? Colors.blueAccent : Colors.grey[300],
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
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  // color: Colors.red,
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Wrap(
                    children: [
                      Image.network(
                        "https://via.placeholder.com/160",
                      ),
                      Image.network(
                        "https://via.placeholder.com/160",
                      ),
                      Image.network(
                        "https://via.placeholder.com/160",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
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
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(userImageUrl),
            ),
        ],
      ),
    );
  }
}

var testMessages = const [
  ChatBubbleWidget(
    message: 'Hi!',
    isMe: true,
    time: '10:30 AM',
    userImageUrl: 'https://via.placeholder.com/160',
  ),
  ChatBubbleWidget(
    message: 'Hey, how are you doing today?',
    isMe: false,
    time: '10:31 AM',
    userImageUrl: 'https://via.placeholder.com/160',
  ),
  ChatBubbleWidget(
    message: 'I’ve been really busy lately with work and some personal stuff, '
        'but I’m doing well overall. It’s been a long week though. '
        'How about you? What have you been up to these days?',
    isMe: true,
    time: '10:35 AM',
    userImageUrl: 'https://via.placeholder.com/160',
  ),
  ChatBubbleWidget(
    message:
        'Hey! So I’ve been meaning to tell you about this amazing trip I had last weekend. '
        'We went hiking up the mountain, and it was such an incredible experience. '
        'The weather was perfect, the views were breathtaking, and I got some really great photos. '
        'Honestly, I think it was one of the best trips I’ve ever had. We also found a hidden waterfall, '
        'which wasn’t even on the map, and spent a couple of hours just relaxing there. '
        'I wish I could show you the pictures right now!',
    isMe: false,
    time: '10:45 AM',
    userImageUrl: 'https://via.placeholder.com/160',
  ),
  ChatBubbleWidget(
    message: 'Sure.',
    isMe: true,
    time: '10:40 AM',
    userImageUrl: 'https://via.placeholder.com/160',
  ),
  ChatBubbleWidget(
    message: 'Great job! 👍',
    isMe: false,
    time: '10:42 AM',
    userImageUrl: 'https://via.placeholder.com/160',
  ),
];

class MessageBox extends StatelessWidget {
  final void Function()? onTapSend;
  const MessageBox({
    super.key,
    this.onTapSend,
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
            onTap: onTapSend,
            child: const Icon(
              Icons.send,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
