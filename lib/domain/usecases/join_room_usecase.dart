import 'package:chat_app/domain/repository/room_repository.dart';

class JoinRoomUsecase {
  RoomRepository? repository;
  JoinRoomUsecase({this.repository});

  Future<void> invoke({String? userId, String? roomId}) {
    return repository!.joinRoom(userId: userId, roomId: roomId);
  }
}
