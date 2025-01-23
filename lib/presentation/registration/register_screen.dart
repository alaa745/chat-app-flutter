import 'dart:io';

import 'package:chat_app/presentation/login/login_screen.dart';
import 'package:chat_app/presentation/login/login_screen_arguments.dart';
import 'package:chat_app/presentation/registration/register_screen_viewmodel.dart';
import 'package:chat_app/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'register';

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController fullNameController = TextEditingController();

  bool isLoading = false;
  late RegisterScreenViewmodel _viewmodel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewmodel = RegisterScreenViewmodel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _viewmodel,
      listener: (context, state) {
        if (state is RegisterLoadingState) {
          print('loadiiiiiing');
          isLoading = true;
        } else if (state is RegisterFailState) {
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
        if (previous is RegisterLoadingState) {
          isLoading = false;
        }
        if (current is RegisterLoadingState || current is RegisterFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is RegisterSuccessState) {
          print('user data is ${state.credential.user!.email}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName , arguments: LoginScreenArguments(fullName: fullNameController.text));
          });
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/login_header.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * .25,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.name,
                              controller: fullNameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 25),
                            ),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 25),
                            ),
                            TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      height: 60,
                      margin: EdgeInsets.only(bottom: 100),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _viewmodel.registerUser(emailController.text,
                              passwordController.text, fullNameController.text);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Create Account',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                'images/arrow_right.png',
                                color: Colors.grey,
                              )
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
        );
      },
    );
  }
}
