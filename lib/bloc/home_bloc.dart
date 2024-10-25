import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/room.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadRooms>(_loadRooms);
  }

  Future<void> _loadRooms(LoadRooms event, Emitter<HomeState> emit) async {
    // Fetch rooms from Firebase or any other data source
    List<Room> rooms = [
      Room(
        roomId: '123',
        name: 'Flutter Devs',
        creatorId: 'user1',
      ),
      Room(
        roomId: '${DateTime.now().microsecondsSinceEpoch}',
        name: 'Flutter Devs',
        creatorId: 'user1',
      ),
      Room(
        roomId: '${DateTime.now().microsecondsSinceEpoch}',
        name: 'WebRTC Group',
        creatorId: 'user2',
      ),
    ];

    emit(HomeLoaded(rooms: rooms));
  }
}
