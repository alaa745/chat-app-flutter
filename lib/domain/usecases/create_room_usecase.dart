import 'package:chat_app/domain/repository/room_repository.dart';

class CreateRoomUsecase {
  RoomRepository repository;

  CreateRoomUsecase({required this.repository});

  Future<void> invoke(String name, String description , String member) async {
    return repository.createRoom(name, description , member);
  }
}
