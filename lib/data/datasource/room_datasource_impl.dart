import 'package:chat_app/data/firebase_manager.dart';
import 'package:chat_app/domain/datasource/room_datasource.dart';
import 'package:chat_app/domain/models/message_model.dart';
import 'package:chat_app/domain/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class RoomDatasourceImpl implements RoomDatasource {
  FirebaseManager firebaseManager;

  RoomDatasourceImpl({required this.firebaseManager});
  @override
  Future<void> createRoom(
      String roomName, String roomDescription, String member) {
    return firebaseManager.createRoom(roomName, roomDescription, member);
  }

  @override
  Stream<QuerySnapshot<RoomModel>> getRooms() {
    return firebaseManager.getRooms();
  }

  @override
  Future<void> joinRoom({String? userId, String? roomId}) {
    return firebaseManager.joinRoom(userId, roomId);
  }

  @override
  Stream<QuerySnapshot<MessageModel>> getMessages(String roomId) {
    return firebaseManager.getMessages(roomId);
  }

  @override
  Future<void> sendMessage(String roomId, String message , String userName) {
    return firebaseManager.sendMessage(roomId, message , userName);
  }
}
