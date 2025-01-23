import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDatasource {
  Future<UserCredential> loginUser(String email, String password);
  Future<UserCredential> registerUser(
      String email, String password, String fullName);
}
