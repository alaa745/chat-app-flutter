import 'package:chat_app/customException/custom_exception.dart';
import 'package:chat_app/data/datasource/room_datasource_impl.dart';
import 'package:chat_app/data/firebase_manager.dart';
import 'package:chat_app/data/repository/room_repository_impl.dart';
import 'package:chat_app/domain/datasource/room_datasource.dart';
import 'package:chat_app/domain/repository/room_repository.dart';
import 'package:chat_app/domain/usecases/join_room_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinRoomScreenViewmodel extends Cubit<JoinRoomViewState> {
  late FirebaseManager _firebaseManager;
  late RoomDatasource _datasource;
  late RoomRepository _repository;
  late JoinRoomUsecase _usecase;
  JoinRoomScreenViewmodel() : super(JoinRoomInitialState()) {
    _firebaseManager = FirebaseManager();
    _datasource = RoomDatasourceImpl(firebaseManager: _firebaseManager);
    _repository = RoomRepositoryImpl(roomDatasource: _datasource);
    _usecase = JoinRoomUsecase(repository: _repository);
  }

  void joinRoom({String? userId, String? roomId}) {
    try {
      emit(JoinRoomLoadingState(loadingMessage: 'Joining room...'));
      _usecase.invoke(userId: userId, roomId: roomId);
      emit(JoinRoomSuccessState());
    } on ServerErrorException catch (e) {
      emit(JoinRoomFailState(e.errorMessage));
    }
  }
}

abstract class JoinRoomViewState {}

class JoinRoomInitialState extends JoinRoomViewState {}

class JoinRoomLoadingState extends JoinRoomViewState {
  String loadingMessage;
  JoinRoomLoadingState({required this.loadingMessage});
}

class JoinRoomSuccessState extends JoinRoomViewState {}

class JoinRoomFailState extends JoinRoomViewState {
  String? errorMessage;
  JoinRoomFailState(this.errorMessage);
}
