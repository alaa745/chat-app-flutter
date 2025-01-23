import 'package:chat_app/domain/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends Cubit<CurrentUserState> {
  UserProvider() : super(LoggedOutState()) {
    getIfUserLogin();
  }

  void login(LoggedInState loggedInState) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(loggedInState.user.email);
// Store tokens

    sharedPreferences.setBool('login', true);
    // sharedPreferences.setString('token', loggedInState.token);
    sharedPreferences.setString('fullName', loggedInState.user.fullName!);

    sharedPreferences.setString('userEmail', loggedInState.user.email!);
    sharedPreferences.setString('userId', loggedInState.user.id ?? '');
    // sharedPreferences.setString('userReview', loggedInState.user.r!);

    emit(loggedInState);
  }

  void logout(LoggedOutState loggedOutState) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.setBool('login', false);
    emit(loggedOutState);
  }

  void getIfUserLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? fullName = sharedPreferences.getString('fullName');

    String? email = sharedPreferences.getString('userEmail');
    String? id = sharedPreferences.getString('userId');
    bool? isLogin = sharedPreferences.getBool('login') ?? false;
    print(isLogin);
    print(fullName);
    if (isLogin) {
      emit(
        LoggedInState(
          user: UserModel(
            fullName: fullName,
            email: email,
            id: id,
          ),
        ),
      );
    }
  }
}

abstract class CurrentUserState {}

class LoggedInState extends CurrentUserState {
  UserModel user;

  LoggedInState({
    required this.user,
  });
}

class LoggedOutState extends CurrentUserState {}
