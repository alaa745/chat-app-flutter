import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  String? id;
  String? name;
  String? description;
  String? createdBy;
  List<dynamic>? members;
  RoomModel({this.id, this.name, this.description, this.members , this.createdBy});

  factory RoomModel.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return RoomModel(
      id: data?['id'],
      name: data?['name'],
      description: data?['description'],
      members: data?['members'],
      createdBy: data?['created By'],

    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (id != null) "id": id,
      if (members != null) "members": members,
      if (createdBy != null) "created By": createdBy,

    };
  }
}
