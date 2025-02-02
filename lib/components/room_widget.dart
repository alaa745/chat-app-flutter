import 'package:chat_app/domain/models/room_model.dart';
import 'package:chat_app/presentation/chat_screen/chat_screen.dart';
import 'package:chat_app/presentation/chat_screen/chat_screen_arguments.dart';
import 'package:chat_app/presentation/join_room/join_room_screen.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomWidget extends StatelessWidget {
  RoomModel? roomModel;
  RoomWidget({required this.roomModel});

  @override
  Widget build(BuildContext context) {
    String userId = '', email = '';
    UserProvider userProvider = BlocProvider.of(context, listen: true);
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      userId = loggedInState.user.id!;
      email = loggedInState.user.email!;
    }
    return InkWell(
      onTap: () {
        print("user id: $userId");
        print("user email: ${email}");

        print("room id: ${roomModel!.id}");

        !roomModel!.members!.contains(userId)
            ? Navigator.pushNamed(context, JoinRoomScreen.routeName,
                arguments: <String, dynamic>{
                    'userId': userId,
                    'roomId': roomModel!.id,
                    'roomName': roomModel!.name,
                    'roomDesc': roomModel!.description
                  })
            : Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: ChatScreenArguments(roomModel: roomModel!),
              );
      },
      child: Card(
        color: Colors.white,
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'images/movie_room.png',
                width: 90,
                height: 85,
              ),
              Text(
                roomModel!.name!,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '${roomModel!.members!.length} members',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
