import 'package:chat_app/data/firebase_manager.dart';
import 'package:chat_app/domain/datasource/auth_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthDatasourceImpl implements AuthDatasource {
  FirebaseManager firebaseManager;

  AuthDatasourceImpl({required this.firebaseManager});
  @override
  Future<UserCredential> loginUser(String email, String password) {
    return firebaseManager.loginUser(email, password);
  }

  @override
  Future<UserCredential> registerUser(
      String email, String password, String fullName) {
    return firebaseManager.registerUser(email, password, fullName);
  }
}
