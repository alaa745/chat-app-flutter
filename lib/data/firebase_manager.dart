import 'package:chat_app/customException/custom_exception.dart';
import 'package:chat_app/domain/models/message_model.dart';
import 'package:chat_app/domain/models/room_model.dart';
import 'package:chat_app/domain/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseManager {
  Future<UserCredential> loginUser(String email, String password) async {
    late UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ServerErrorException(
            errorMessage: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ServerErrorException(
            errorMessage: 'Wrong password provided for that user.');
      } else {
        throw ServerErrorException(errorMessage: e.toString());
      }
    }
  }

  Future<UserCredential> registerUser(
      String email, String password, String fullName) async {
    late UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await insertUser(fullName, email, credential.user!.uid);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ServerErrorException(errorMessage: 'The password is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw ServerErrorException(errorMessage: 'Email is already exist');
      } else {
        throw ServerErrorException(errorMessage: e.toString());
      }
    }
  }

  Future<void> insertUser(String fullName, String email, String id) async {
    try {
      var db = FirebaseFirestore.instance;
      final user = UserModel(fullName: fullName, email: email, id: id);
      final docRef = db
          .collection("users")
          .withConverter(
            fromFirestore: UserModel.fromFireStore,
            toFirestore: (UserModel user, options) => user.toFireStore(),
          )
          .doc(user.id);
      await docRef.set(user);
    } on FirebaseException catch (e) {
      throw ServerErrorException(errorMessage: e.message!);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  Future<void> createRoom(
      String roomName, String roomDescription, String member) async {
    List<String> members = [];
    members.add(member);
    try {
      var db = FirebaseFirestore.instance;
      final room = RoomModel(
          name: roomName,
          description: roomDescription,
          members: members,
          createdBy: member);
      final docRef = db
          .collection("rooms")
          .withConverter(
            fromFirestore: RoomModel.fromFireStore,
            toFirestore: (RoomModel room, options) => room.toFireStore(),
          )
          .doc();
      room.id = docRef.id;
      await docRef.set(room);
    } on FirebaseException catch (e) {
      throw ServerErrorException(errorMessage: e.message!);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  Future<void> joinRoom(String? userId, String? roomId) async {
    var db = FirebaseFirestore.instance;
    final roomRef = db.collection("rooms").doc(roomId).withConverter(
          fromFirestore: RoomModel.fromFireStore,
          toFirestore: (RoomModel room, _) => room.toFireStore(),
        );
    var docSnapShot = await roomRef.get();
    var members = docSnapShot.data()!.members;
    members?.add(userId);
    return roomRef.update({
      "members": members,
    });
  }

  Stream<QuerySnapshot<RoomModel>> getRooms() {
    try {
      var db = FirebaseFirestore.instance;
      return db
          .collection("rooms")
          .withConverter(
            fromFirestore: RoomModel.fromFireStore,
            toFirestore: (RoomModel room, options) => room.toFireStore(),
          )
          .snapshots();
    } on FirebaseException catch (e) {
      throw ServerErrorException(errorMessage: e.message!);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      var db = FirebaseFirestore.instance;
      var ref = db.collection("users").doc(userId).withConverter(
            fromFirestore: UserModel.fromFireStore,
            toFirestore: (UserModel user, _) => user.toFireStore(),
          );
      final docSnap = await ref.get();
      final user = docSnap.data();

      return user;
    } on FirebaseException catch (e) {
      throw ServerErrorException(errorMessage: e.message!);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  // send message to room document
  Future<void> sendMessage(
      {required String roomId,
      required String userName,
      required String message,
      required String sender}) async {
    var db = FirebaseFirestore.instance;
    final messageModel = MessageModel(
      message: message,
      senderId: sender,
      userName: userName,
      dateTime: DateTime.now(),
    );
    final docRef = db
        .collection("rooms")
        .doc(roomId)
        .collection("messages")
        .withConverter<MessageModel>(
          fromFirestore: MessageModel.fromFireStore,
          toFirestore: (message, options) => message.toFireStore(),
        )
        .doc();
    await docRef.set(messageModel);
  }

  // get messages from room document
  Stream<QuerySnapshot<MessageModel>> getMessages(String roomId) {
    try {
      var db = FirebaseFirestore.instance;

      return db
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .withConverter(
            fromFirestore: MessageModel.fromFireStore,
            toFirestore: (MessageModel message, _) => message.toFireStore(),
          )
          .orderBy("dateTime")
          .snapshots();
    } on FirebaseException catch (e) {
      throw ServerErrorException(errorMessage: e.message!);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }
}
