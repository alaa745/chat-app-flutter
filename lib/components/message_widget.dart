import 'package:chat_app/domain/models/message_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageWidget extends StatelessWidget {
  MessageModel messageModel;
  MessageWidget({required this.messageModel});

  @override
  Widget build(BuildContext context) {
    late String userId;
    UserProvider userProvider = BlocProvider.of(context);
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      userId = loggedInState.user.id!;
    }
    return messageModel.senderId == userId
        ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 50,
              // width: 0,
              decoration: BoxDecoration(
                color: Color(0xFf3598DB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  messageModel.message,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  messageModel.message,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
  }
}
