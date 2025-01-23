import 'package:chat_app/customException/custom_exception.dart';
import 'package:chat_app/data/datasource/auth_datasource_impl.dart';
import 'package:chat_app/data/firebase_manager.dart';
import 'package:chat_app/data/repository/auth_repository_impl.dart';
import 'package:chat_app/domain/datasource/auth_datasource.dart';
import 'package:chat_app/domain/repository/auth_repository.dart';
import 'package:chat_app/domain/usecases/login_usecase.dart';
import 'package:chat_app/domain/usecases/register_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreenViewmodel extends Cubit<RegisterViewState> {
  late FirebaseManager firebaseManager;
  late RegisterUsecase _registerUsecase;
  late AuthDatasource _authDatasource;
  late AuthRepository _authRepository;

  RegisterScreenViewmodel() : super(RegisterInitialState()) {
    firebaseManager = FirebaseManager();
    _authDatasource = AuthDatasourceImpl(firebaseManager: firebaseManager);
    _authRepository = AuthRepositoryImpl(authDatasource: _authDatasource);
    _registerUsecase = RegisterUsecase(authRepository: _authRepository);
  }

  void registerUser(String email, String password, String fullName) async {
    emit(RegisterLoadingState(loadingMessage: 'Loading...'));

    try {
      var userCredential =
          await _registerUsecase.invoke(email, password, fullName);
      emit(RegisterSuccessState(credential: userCredential));
    } on ServerErrorException catch (e) {
      emit(RegisterFailState(errorMessage: e.errorMessage));
    }
  }
}

abstract class RegisterViewState {}

class RegisterInitialState extends RegisterViewState {}

class RegisterLoadingState extends RegisterViewState {
  String loadingMessage;

  RegisterLoadingState({required this.loadingMessage});
}

class RegisterSuccessState extends RegisterViewState {
  UserCredential credential;

  RegisterSuccessState({required this.credential});
}

class RegisterFailState extends RegisterViewState {
  String errorMessage;

  RegisterFailState({required this.errorMessage});
}
