import 'package:chat_app/customException/custom_exception.dart';
import 'package:chat_app/data/datasource/auth_datasource_impl.dart';
import 'package:chat_app/data/datasource/room_datasource_impl.dart';
import 'package:chat_app/data/firebase_manager.dart';
import 'package:chat_app/data/repository/auth_repository_impl.dart';
import 'package:chat_app/data/repository/room_repository_impl.dart';
import 'package:chat_app/domain/datasource/auth_datasource.dart';
import 'package:chat_app/domain/datasource/room_datasource.dart';
import 'package:chat_app/domain/repository/auth_repository.dart';
import 'package:chat_app/domain/repository/room_repository.dart';
import 'package:chat_app/domain/usecases/create_room_usecase.dart';
import 'package:chat_app/domain/usecases/login_usecase.dart';
import 'package:chat_app/domain/usecases/register_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRoomScreenViewmodel extends Cubit<CreateRoomViewState> {
  late FirebaseManager firebaseManager;
  late CreateRoomUsecase _createRoomUsecase;
  late RoomRepository _repository;
  late RoomDatasource _datasource;

  CreateRoomScreenViewmodel() : super(CreateRoomInitialState()) {
    firebaseManager = FirebaseManager();
    _datasource = RoomDatasourceImpl(firebaseManager: firebaseManager);
    _repository = RoomRepositoryImpl(roomDatasource: _datasource);
    _createRoomUsecase = CreateRoomUsecase(repository: _repository);
  }

  void createRoom(String name, String description , String member) async {
    emit(CreateRoomLoadingState(loadingMessage: 'Loading...'));

    try {
      await _createRoomUsecase.invoke(name, description , member);
      emit(CreateRoomSuccessState());
    } on ServerErrorException catch (e) {
      emit(CreateRoomFailState(errorMessage: e.errorMessage));
    }
  }
}

abstract class CreateRoomViewState {}

class CreateRoomInitialState extends CreateRoomViewState {}

class CreateRoomLoadingState extends CreateRoomViewState {
  String loadingMessage;

  CreateRoomLoadingState({required this.loadingMessage});
}

class CreateRoomSuccessState extends CreateRoomViewState {}

class CreateRoomFailState extends CreateRoomViewState {
  String errorMessage;

  CreateRoomFailState({required this.errorMessage});
}
