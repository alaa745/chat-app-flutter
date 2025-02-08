import 'package:chat_app/customException/custom_exception.dart';
import 'package:chat_app/data/datasource/room_datasource_impl.dart';
import 'package:chat_app/data/firebase_manager.dart';
import 'package:chat_app/data/repository/room_repository_impl.dart';
import 'package:chat_app/domain/datasource/room_datasource.dart';
import 'package:chat_app/domain/models/message_model.dart';
import 'package:chat_app/domain/repository/room_repository.dart';
import 'package:chat_app/domain/usecases/get_message_usecase.dart';
import 'package:chat_app/domain/usecases/join_room_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreenViewmodel extends Cubit<ChatScreenViewState> {
  late FirebaseManager _firebaseManager;
  late RoomDatasource _datasource;
  late RoomRepository _repository;
  late GetMessageUsecase _getMessageUsecase;
  late SendMessageUsecase _sendMessageUsecase;
  ChatScreenViewmodel() : super(ChatScreenLoadingState("loading...")) {
    _firebaseManager = FirebaseManager();
    _datasource = RoomDatasourceImpl(firebaseManager: _firebaseManager);
    _repository = RoomRepositoryImpl(roomDatasource: _datasource);
    _getMessageUsecase = GetMessageUsecase(repository: _repository);
    _sendMessageUsecase = SendMessageUsecase(repository: _repository);
  }

  void getMessages({required String roomId}) async {
    List<MessageModel> messages = [];
    String userName = "";
    try {
      _getMessageUsecase.invoke(roomId).listen((snapshot) {
        messages = snapshot.docs.map((doc) => doc.data()).toList();
        emit(GetMessagesSuccessState(List.from(messages)));
      });
    } on ServerErrorException catch (e) {
      emit(GetMessagesFailState(e.errorMessage));
    }
  }

  void sendMessage(
      {required String roomId,
      required String message,
      required String userId,
      required String userName}) {
    try {
      _sendMessageUsecase.invoke(roomId, message, userId, userName);
      // emit(SendMessagesSuccessState());
    } on ServerErrorException catch (e) {
      emit(SendMessagesFailState(e.errorMessage));
    }
  }
}

abstract class ChatScreenViewState {}

class ChatScreenLoadingState extends ChatScreenViewState {
  String? loadingMessage;
  ChatScreenLoadingState(this.loadingMessage);
}

class GetMessagesSuccessState extends ChatScreenViewState {
  List<MessageModel>? messages;
  GetMessagesSuccessState(this.messages);
}

class GetMessagesFailState extends ChatScreenViewState {
  String? errorMessage;
  GetMessagesFailState(this.errorMessage);
}

class SendMessagesSuccessState extends ChatScreenViewState {}

class SendMessagesFailState extends ChatScreenViewState {
  String? errorMessage;
  SendMessagesFailState(this.errorMessage);
}
