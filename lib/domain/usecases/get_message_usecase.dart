import 'package:chat_app/domain/models/message_model.dart';
import 'package:chat_app/domain/repository/room_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetMessageUsecase {
  RoomRepository repository;

  GetMessageUsecase({required this.repository});

  Stream<QuerySnapshot<MessageModel>> invoke(String roomId) {
    return repository.getMessages(roomId);
  }
}
