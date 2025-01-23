import 'package:chat_app/domain/datasource/auth_datasource.dart';
import 'package:chat_app/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthDatasource authDatasource;

  AuthRepositoryImpl({required this.authDatasource});

  @override
  Future<UserCredential> loginUser(String email, String password) {
    return authDatasource.loginUser(email, password);
  }

  @override
  Future<UserCredential> registerUser(
      String email, String password, String fullName) {
    return authDatasource.registerUser(email, password, fullName);
  }
}
