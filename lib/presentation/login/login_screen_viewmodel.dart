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

class LoginScreenViewmodel extends Cubit<LoginViewState> {
  late FirebaseManager firebaseManager;
  late LoginUsecase _loginUsecase;
  late AuthDatasource _authDatasource;
  late AuthRepository _authRepository;

  LoginScreenViewmodel() : super(LoginInitialState()) {
    firebaseManager = FirebaseManager();
    _authDatasource = AuthDatasourceImpl(firebaseManager: firebaseManager);
    _authRepository = AuthRepositoryImpl(authDatasource: _authDatasource);
    _loginUsecase = LoginUsecase(authRepository: _authRepository);
  }

  void loginUser(String email, String password) async {
    emit(LoginLoadingState(loadingMessage: 'Loading...'));

    try {
      var userCredential = await _loginUsecase.invoke(email, password);
      emit(LoginSuccessState(credential: userCredential));
    } on ServerErrorException catch (e) {
      emit(LoginFailState(errorMessage: e.errorMessage));
    }
  }
}

abstract class LoginViewState {}

class LoginInitialState extends LoginViewState {}

class LoginLoadingState extends LoginViewState {
  String loadingMessage;

  LoginLoadingState({required this.loadingMessage});
}

class LoginSuccessState extends LoginViewState {
  UserCredential credential;

  LoginSuccessState({required this.credential});
}

class LoginFailState extends LoginViewState {
  String errorMessage;

  LoginFailState({required this.errorMessage});
}
