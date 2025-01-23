import 'package:chat_app/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterUsecase {
  AuthRepository authRepository;

  RegisterUsecase({required this.authRepository});

  Future<UserCredential> invoke(String email, String password , String fullName) async {
    return authRepository.registerUser(email, password , fullName);
  }
}
