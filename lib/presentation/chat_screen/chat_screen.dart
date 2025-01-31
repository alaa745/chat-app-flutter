import 'package:chat_app/components/message_widget.dart';
import 'package:chat_app/domain/models/message_model.dart';
import 'package:chat_app/domain/models/room_model.dart';
import 'package:chat_app/presentation/chat_screen/chat_screen_arguments.dart';
import 'package:chat_app/presentation/chat_screen/chat_screen_viewmodel.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/send_button_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "Chat";
  ChatScreen();

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  late ChatScreenArguments arguments;
  late RoomModel roomModel;
  late ChatScreenViewmodel _viewmodel;
  late String senderId;
  TextEditingController _controller = TextEditingController(text: "");
  bool isSendable = false;
  int messagesCount = 0;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SendButtonProvider>(context, listen: false)
          .changeIsSendable(false);
    });
    arguments =
        ModalRoute.of(context)!.settings.arguments as ChatScreenArguments;
    roomModel = arguments.roomModel;
    // _viewmodel.getMessages(roomId: roomModel.id!);
  }

  @override
  void initState() {
    // TODO: implement initState
    _viewmodel = ChatScreenViewmodel();

    super.initState();
  }

  bool _isAtBottom() {
    if (!_scrollController.hasClients) return false;
    const threshold =
        100.0; // Pixels from the bottom to consider "at the bottom"
    return _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels <=
        threshold;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = BlocProvider.of<UserProvider>(context);
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      senderId = loggedInState.user.id!;
      print('user is ${loggedInState.user.email}');
    } else {
      print('user is not logged in');
    }
    return BlocConsumer(
      bloc: _viewmodel..getMessages(roomId: roomModel.id!),
      listenWhen: (previous, current) {
        if (current is GetMessagesFailState ||
            current is SendMessagesFailState ||
            current is ChatScreenLoadingState) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is GetMessagesFailState) {
          if (kIsWeb) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ));
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Fail'),
                    content: Text(state.errorMessage!),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'))
                    ],
                  );
                });
          }
        } else if (state is SendMessagesFailState) {
          if (kIsWeb) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ));
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Fail'),
                    content: Text(state.errorMessage!),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'))
                    ],
                  );
                });
          }
        }
      },
      builder: (context, state) {
        List<MessageModel> messages = [];
        if (state is GetMessagesSuccessState) {
          if (messages.length < state.messages!.length) {
            // print(messages.length);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 800),
                curve: Curves.linear,
              );
            });
          }
          messages = state.messages!;
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("images/login_header.png"),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                roomModel.name!,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              automaticallyImplyLeading: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: MediaQuery.sizeOf(context).height * .77,
                margin: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * .03),
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) =>
                              MessageWidget(messageModel: messages[index]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.send,
                          onChanged: (value) {
                            if (value.trim().isNotEmpty) {
                              isSendable = true;
                              Provider.of<SendButtonProvider>(context,
                                      listen: false)
                                  .changeIsSendable(isSendable);
                              // print(isSendable);
                            } else {
                              isSendable = false;
                              Provider.of<SendButtonProvider>(context,
                                      listen: false)
                                  .changeIsSendable(isSendable);
                            }
                          },
                          onSubmitted: (value) {
                            if (Provider.of<SendButtonProvider>(context,
                                    listen: false)
                                .isSendable) {
                              _viewmodel.sendMessage(
                                  roomId: roomModel.id!,
                                  message: _controller.text,
                                  userId: senderId);
                              _controller.clear();
                              Provider.of<SendButtonProvider>(context,
                                      listen: false)
                                  .changeIsSendable(false);
                            }
                          },
                          decoration: InputDecoration(
                            suffixIcon: Consumer<SendButtonProvider>(
                              builder: (context, notifier, child) {
                                return InkWell(
                                  onTap: notifier.isSendable
                                      ? () {
                                          _viewmodel.sendMessage(
                                              roomId: roomModel.id!,
                                              message: _controller.text,
                                              userId: senderId);
                                          _controller.clear();
                                          isSendable = false;
                                          notifier.changeIsSendable(isSendable);
                                          // if (_scrollController
                                          //         .position.pixels !=
                                          //     _scrollController
                                          //         .position.maxScrollExtent) {
                                          //   _scrollController.animateTo(
                                          //     _scrollController
                                          //         .position.maxScrollExtent,
                                          //     duration: const Duration(
                                          //         milliseconds: 700),
                                          //     curve: Curves.linear,
                                          //   );
                                          // }
                                        }
                                      : null,
                                  child: Icon(
                                    Icons.send_rounded,
                                    color: notifier.isSendable
                                        ? Color(0xFf3598DB)
                                        : Colors.grey,
                                  ),
                                );
                              },
                            ),
                            hintText: "Type a message",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            // enabledBorder:
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
