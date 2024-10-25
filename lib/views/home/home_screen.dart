import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webrtc_messaging_app/models/room.dart';
import '../chat/chat_screen.dart';
import '/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ...List.generate(
            10,
            (index) => const RoomItem(),
          ),
        ],
      ),
    );
  }
}

class RoomItem extends StatelessWidget {
  final Room? room;
  const RoomItem({
    super.key,
    this.room,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 16.0,
      ),
      leading: const CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(
          "https://eu.ui-avatars.com/api/?name=Sa&size=150",
        ),
      ),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Flutter Devs",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            "12:30 PM",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          const Expanded(
            child: Text(
              "Let's meet at 5 PM!",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        var queryParams = {
          'roomId': '123',
        };
        context.goNamed(
          AppRoutes.chatNamed,
          queryParameters: queryParams,
        );

        kPrint('Tapped on room: Flutter Devs');
      },
    );
  }
}
