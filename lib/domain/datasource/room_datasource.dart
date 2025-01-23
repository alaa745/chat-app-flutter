import 'package:chat_app/domain/models/message_model.dart';
import 'package:chat_app/domain/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RoomDatasource {
  Future<void> createRoom(
      String roomName, String roomDescription, String member);
  Stream<QuerySnapshot<RoomModel>> getRooms();
  Future<void> joinRoom({String? userId, String? roomId});

  Future<void> sendMessage(String roomId, String message , String userName);

  Stream<QuerySnapshot<MessageModel>> getMessages(String roomId);
}
