import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? fullName;
  String? email;

  UserModel({this.fullName, this.email, this.id});

  factory UserModel.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return UserModel(
      fullName: data?['fullName'],
      email: data?['email'],
      id: data?['id'],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (fullName != null) "fullName": fullName,
      if (email != null) "email": email,
      if (id != null) "id": id,

    };
  }
}
