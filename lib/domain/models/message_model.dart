import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final bool isSender;
  final String senderId;
  final DateTime date;

  MessageModel({
    required this.message,
    required this.isSender,
    required this.date,
    required this.senderId,
  });

  // from firestore
  factory MessageModel.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> data, SnapshotOptions? options) {
    return MessageModel(
      message: data['message'],
      isSender: data['isSender'],
      senderId: data['senderId'],
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // to firestore
  Map<String, dynamic> toFireStore() {
    return {
      'message': message,
      'isSender': isSender,
      'date': date,
      'senderId': senderId,
    };
  }
}
