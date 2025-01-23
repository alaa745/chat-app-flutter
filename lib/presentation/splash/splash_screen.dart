import 'package:chat_app/presentation/home/home_screen.dart';
import 'package:chat_app/presentation/login/login_screen.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = 'splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: true);
    Future.delayed(Duration(seconds: 2), () {
      userProvider.state is LoggedInState
          ? Navigator.pushReplacementNamed(context, HomeScreen.routeName)
          : Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });
    return Image.asset(
      'images/splash.png',
      fit: BoxFit.cover,
    );
  }
}
