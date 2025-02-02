import 'dart:io';

import 'package:chat_app/presentation/join_room/join_room_screen_viewmodel.dart';
import 'package:chat_app/utils/dialog_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinRoomScreen extends StatefulWidget {
  static const routeName = 'join';
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  late JoinRoomScreenViewmodel _viewmodel;
  bool isLoading = false;
  Map<String, dynamic>? arguments;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewmodel = JoinRoomScreenViewmodel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _viewmodel,
      listenWhen: (previous, current) {
        if (current is JoinRoomLoadingState || current is JoinRoomFailState) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is JoinRoomLoadingState) {
          print('loadiiiiiing');
          isLoading = true;
        } else if (state is JoinRoomFailState) {
          if (Platform.isIOS) {
            DialogUtils.showDialogIos(
                alertMsg: 'Fail',
                alertContent: state.errorMessage,
                context: context);
          } else {
            DialogUtils.showDialogAndroid(
                alertMsg: 'Fail',
                alertContent: state.errorMessage,
                context: context);
          }
        }
      },
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage(
                  'images/login_header.png',
                ),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                arguments!["roomName"],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              automaticallyImplyLeading: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).height * .06),
                    padding: EdgeInsets.only(left: 15, right: 15),
                    // height: MediaQuery.sizeOf(context).height * .7,
                    width: double.infinity,
                    child: Card(
                      color: Colors.white,
                      elevation: 7,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              child: const Text(
                                'Hello, Welcome to our chat room',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              // margin: EdgeInsets.only(top: 5),
                              child: Text(
                                'Join The ${arguments!["roomName"]} Room',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Image.asset(
                              'images/create_room.png',
                              width: 200,
                              height: 200,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(top: 40),
                                child: Text(
                                  arguments!["roomDesc"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  maxLines: 4,
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              margin: EdgeInsets.only(top: 80, bottom: 30),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3598DB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  print("user Id ${arguments!['userId']}");
                                  print("room Id ${arguments!['roomId']}");
                                  _viewmodel.joinRoom(
                                      userId: arguments!['userId'],
                                      roomId: arguments!['roomId']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Join',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset('images/arrow_right.png')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
