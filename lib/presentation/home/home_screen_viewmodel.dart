import 'package:chat_app/customException/custom_exception.dart';
import 'package:chat_app/data/datasource/room_datasource_impl.dart';
import 'package:chat_app/data/firebase_manager.dart';
import 'package:chat_app/data/repository/room_repository_impl.dart';
import 'package:chat_app/domain/datasource/room_datasource.dart';
import 'package:chat_app/domain/models/room_model.dart';
import 'package:chat_app/domain/repository/room_repository.dart';
import 'package:chat_app/domain/usecases/get_rooms_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenViewmodel extends Cubit<HomeViewState> {
  late FirebaseManager _firebaseManager;
  late RoomRepository _repository;
  late RoomDatasource _datasource;
  late GetRoomsUsecase _usecase;

  HomeScreenViewmodel() : super(HomeInitialState()) {
    _firebaseManager = FirebaseManager();
    _datasource = RoomDatasourceImpl(firebaseManager: _firebaseManager);
    _repository = RoomRepositoryImpl(roomDatasource: _datasource);
    _usecase = GetRoomsUsecase(_repository);
  }

  void getRooms() async {
    List<RoomModel> rooms = [];
    emit(GetRoomsLoadingState('Loading...'));

    try {
      _usecase.invoke().listen((snapshot) {
        rooms = snapshot.docs.map((doc) => doc.data()).toList();;
        print('roooms ${rooms.length}');
        emit(GetRoomsSuccessState(rooms));
      });
    } on ServerErrorException catch (e) {
      emit(GetRoomsFailState(e.errorMessage));
    }
  }
}

abstract class HomeViewState {}

class HomeInitialState extends HomeViewState {}

class GetRoomsLoadingState extends HomeViewState {
  String? loadingMessage;
  GetRoomsLoadingState(this.loadingMessage);
}

class GetRoomsSuccessState extends HomeViewState {
  List<RoomModel>? rooms;
  GetRoomsSuccessState(this.rooms);
}

class GetRoomsFailState extends HomeViewState {
  String? errorMessage;
  GetRoomsFailState(this.errorMessage);
}
