import 'package:chat_app/domain/models/room_model.dart';
import 'package:chat_app/domain/repository/room_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetRoomsUsecase {
  RoomRepository _repository;
  GetRoomsUsecase(this._repository);

  Stream<QuerySnapshot<RoomModel>> invoke() {
    return _repository.getRooms();
  }
}
