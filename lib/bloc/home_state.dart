part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<Room> rooms;

  HomeLoaded({
    required this.rooms,
  });

  @override
  String toString() => 'HomeLoaded { rooms: $rooms }';

  //copyWith
  HomeLoaded copyWith({
    List<Room>? rooms,
  }) {
    return HomeLoaded(
      rooms: rooms ?? this.rooms,
    );
  }
}
