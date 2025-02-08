import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/presentation/chat_screen/chat_screen.dart';
import 'package:chat_app/presentation/chat_screen/chat_screen_viewmodel.dart';
import 'package:chat_app/presentation/create_room/create_room_screen.dart';
import 'package:chat_app/presentation/home/home_screen.dart';
import 'package:chat_app/presentation/join_room/join_room_screen.dart';
import 'package:chat_app/presentation/login/login_screen.dart';
import 'package:chat_app/presentation/registration/register_screen.dart';
import 'package:chat_app/presentation/splash/splash_screen.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/send_button_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SendButtonProvider(),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashScreen.routeName,
      debugShowCheckedModeBanner: false,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        CreateRoomScreen.routeName: (context) => CreateRoomScreen(),
        JoinRoomScreen.routeName: (context) => JoinRoomScreen(),
        ChatScreen.routeName: (context) => ChatScreen(),
      },
    );
  }
}
