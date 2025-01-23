import 'package:chat_app/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginUsecase {
  AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  Future<UserCredential> invoke(String email, String password) async {
    return authRepository.loginUser(email, password);
  }
}
