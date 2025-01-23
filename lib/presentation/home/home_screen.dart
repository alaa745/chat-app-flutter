import 'dart:io';

import 'package:chat_app/components/room_widget.dart';
import 'package:chat_app/domain/models/room_model.dart';
import 'package:chat_app/presentation/create_room/create_room_screen.dart';
import 'package:chat_app/presentation/create_room/create_room_screen_viewmodel.dart';
import 'package:chat_app/presentation/home/home_screen_viewmodel.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  late HomeScreenViewmodel _viewmodel;
  bool isLoading = false;
  List<RoomModel> rooms = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewmodel = HomeScreenViewmodel();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context);
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      print('user is ${loggedInState.user.email}');
    } else {
      print('user is not logged in');
    }
    return BlocConsumer(
      bloc: _viewmodel..getRooms(),
      listenWhen: (previous, current) {
        if (previous is GetRoomsLoadingState) {
          isLoading = false;
        }
        if (current is GetRoomsLoadingState || current is GetRoomsFailState) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is GetRoomsLoadingState) {
          print('loadiiiiiing');
          isLoading = true;
        } else if (state is GetRoomsFailState) {
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
        if (state is GetRoomsSuccessState) {
          rooms = state.rooms!;
          print('roooooooooms ${rooms.length}');
        }
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateRoomScreen.routeName);
            },
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/login_header.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Chat App',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.sizeOf(context).height * .05),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12),
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            return RoomWidget(
                              roomModel: rooms[index],
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       Navigator.pushNamed(context, CreateRoomScreen.routeName);
    //     },
    //     backgroundColor: Colors.blue,
    //     child: const Icon(
    //       Icons.add,
    //       color: Colors.white,
    //       size: 30,
    //     ),
    //   ),
    //   body: Container(
    //     decoration: const BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage(
    //           'images/login_header.png',
    //         ),
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     child: SafeArea(
    //       bottom: false,
    //       child: Padding(
    //         padding: const EdgeInsets.all(15.0),
    //         child: Column(
    //           children: [
    //             const Center(
    //               child: Text(
    //                 'Chat App',
    //                 style: TextStyle(
    //                     fontSize: 30,
    //                     color: Colors.white,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             Expanded(
    //               child: Container(
    //                 margin: EdgeInsets.only(
    //                     top: MediaQuery.sizeOf(context).height * .05),
    //                 child: GridView.builder(
    //                   gridDelegate:
    //                       const SliverGridDelegateWithFixedCrossAxisCount(
    //                           crossAxisCount: 2,
    //                           mainAxisSpacing: 12,
    //                           crossAxisSpacing: 12),
    //                   itemCount: 15,
    //                   itemBuilder: (context, index) {
    //                     return RoomWidget();
    //                   },
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
