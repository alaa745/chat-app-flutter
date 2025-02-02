import 'package:chat_app/domain/repository/room_repository.dart';

class SendMessageUsecase {
  RoomRepository repository;
  SendMessageUsecase({required this.repository});
  Future<void> invoke(
      String roomId, String message, String senderId, String userName) {
    return repository.sendMessage(roomId, message, senderId, userName);
  }
}
