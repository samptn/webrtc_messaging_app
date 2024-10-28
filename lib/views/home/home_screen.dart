import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webrtc_messaging_app/models/room.dart';
import '../../bloc/home_bloc.dart';
import '../chat/chat_screen.dart';
import '/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    context.read<HomeBloc>().add(LoadRooms());
    _createAnonymousUser();
    super.initState();
  }

  _createAnonymousUser() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            return ListView(
              children: [
                ...List.generate(
                  state.rooms.length,
                  (index) {
                    var room = state.rooms[index];
                    return RoomItem(
                      room: room,
                      index: index,
                    );
                  },
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class RoomItem extends StatelessWidget {
  final Room room;
  final int index;
  const RoomItem({
    super.key,
    required this.room,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 16.0,
      ),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(
          "https://picsum.photos/200/300?random=$index",
        ),
      ).animate().fadeIn(
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 500),
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
          'roomId': room.roomId,
        };
        context.pushNamed(
          AppRoutes.chatNamed,
          queryParameters: queryParams,
        );

        kPrint('Tapped on room: Flutter Devs');
      },
    ).animate().show();
  }
}
