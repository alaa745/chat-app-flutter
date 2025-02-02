import 'package:chat_app/domain/datasource/room_datasource.dart';
import 'package:chat_app/domain/models/message_model.dart';
import 'package:chat_app/domain/models/room_model.dart';
import 'package:chat_app/domain/repository/room_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomRepositoryImpl implements RoomRepository {
  RoomDatasource roomDatasource;

  RoomRepositoryImpl({required this.roomDatasource});
  @override
  Future<void> createRoom(
      String roomName, String roomDescription, String member) {
    return roomDatasource.createRoom(roomName, roomDescription, member);
  }

  @override
  Stream<QuerySnapshot<RoomModel>> getRooms() {
    return roomDatasource.getRooms();
  }

  @override
  Future<void> joinRoom({String? userId, String? roomId}) {
    return roomDatasource.joinRoom(userId: userId, roomId: roomId);
  }

  @override
  Stream<QuerySnapshot<MessageModel>> getMessages(String roomId) {
    return roomDatasource.getMessages(roomId);
  }

  @override
  Future<void> sendMessage(
      String roomId, String message, String senderId, String userName) {
    return roomDatasource.sendMessage(roomId, message, senderId, userName);
  }
}
