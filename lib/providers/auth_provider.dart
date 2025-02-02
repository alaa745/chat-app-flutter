import 'package:chat_app/data/firebase_manager.dart';
import 'package:chat_app/domain/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends Cubit<CurrentUserState> {
  final FirebaseManager _firebaseManager = FirebaseManager();
  UserProvider() : super(LoggedOutState()) {
    getIfUserLogin();
  }

  void login(String email, String id) async {
    late UserModel? user;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(email);
    sharedPreferences.setBool('login', true);
    // sharedPreferences.setString('token', loggedInState.token);
    // sharedPreferences.setString('fullName', loggedInState.user.fullName!);
    String? userName = sharedPreferences.getString("userName");
    if (userName == null) {
      user = await _firebaseManager.getUser(id);
      sharedPreferences.setString('userName', user!.fullName!);
    }
    sharedPreferences.setString('userEmail', email);
    sharedPreferences.setString('userId', id);
    // sharedPreferences.setString('userReview', loggedInState.user.r!);
    emit(
      LoggedInState(
        user: UserModel(
          fullName: userName ?? user?.fullName,
          email: email,
          id: id,
        ),
      ),
    );
  }

  void registerFullName(String userName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("userName", userName);
  }

  void logout(LoggedOutState loggedOutState) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.setBool('login', false);
    emit(loggedOutState);
  }

  void getIfUserLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? fullName = sharedPreferences.getString('userName');

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
