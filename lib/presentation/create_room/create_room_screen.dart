import 'dart:io';

import 'package:chat_app/presentation/create_room/create_room_screen_viewmodel.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRoomScreen extends StatefulWidget {
  static const routeName = 'create';
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  bool isLoading = false;
  late CreateRoomScreenViewmodel _viewmodel;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  late UserProvider userProvider;
  late String userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewmodel = CreateRoomScreenViewmodel();
    userProvider = BlocProvider.of<UserProvider>(context, listen: false);
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      userId = loggedInState.user.id!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _viewmodel,
      listener: (context, state) {
        if (state is CreateRoomLoadingState) {
          print('loadiiiiiing');
          isLoading = true;
        } else if (state is CreateRoomFailState) {
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
      listenWhen: (previous, current) {
        if (current is CreateRoomLoadingState ||
            current is CreateRoomFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is CreateRoomSuccessState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('images/login_header.png'),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Text(
                'Chat App',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * .04),
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
                            margin: EdgeInsets.only(top: 20),
                            child: const Text(
                              'Create New Room',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Image.asset(
                            'images/create_room.png',
                            width: 160,
                            height: 80,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            child: Form(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Room Name',
                                      border: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 25),
                                  ),
                                  TextFormField(
                                    controller: descController,
                                    decoration: InputDecoration(
                                      labelText: 'Room Description',
                                      border: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            margin: EdgeInsets.only(top: 80, bottom: 50),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3598DB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                _viewmodel.createRoom(nameController.text,
                                    descController.text, userId);
                                nameController.clear();
                                descController.clear();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Create',
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
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
