import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final String senderId;
  final DateTime dateTime;
  final String userName;
  MessageModel(
      {required this.message,
      required this.dateTime,
      required this.senderId,
      required this.userName});

  // from firestore
  factory MessageModel.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> data, SnapshotOptions? options) {
    return MessageModel(
      message: data['message'],
      senderId: data['senderId'],
      userName: data["userName"],
      dateTime: data['dateTime'] != null
          ? (data['dateTime'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // to firestore
  Map<String, dynamic> toFireStore() {
    return {
      'message': message,
      'dateTime': dateTime,
      'senderId': senderId,
      'userName': userName
    };
  }
}
