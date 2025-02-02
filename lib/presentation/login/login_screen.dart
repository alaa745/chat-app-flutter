import 'dart:io';

import 'package:chat_app/domain/models/user_model.dart';
import 'package:chat_app/presentation/home/home_screen.dart';
import 'package:chat_app/presentation/login/login_screen_arguments.dart';
import 'package:chat_app/presentation/login/login_screen_viewmodel.dart';
import 'package:chat_app/presentation/registration/register_screen.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  late LoginScreenViewmodel _viewmodel;
  bool isLoading = false;
  late String? fullName;
  LoginScreenArguments? args;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewmodel = LoginScreenViewmodel();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (args != null) {
      args = ModalRoute.of(context)!.settings.arguments as LoginScreenArguments;
      fullName = args?.fullName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _viewmodel,
      listenWhen: (previous, current) {
        if (current is LoginLoadingState || current is LoginFailState) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is LoginLoadingState) {
          print('loadiiiiiing');
          isLoading = true;
        } else if (state is LoginFailState) {
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
        if (state is LoginSuccessState) {
          UserProvider userProvider = BlocProvider.of<UserProvider>(context);
          print('user logged in ${state.credential.user!.email}');
          userProvider.login(
            state.credential.user!.email!,
            state.credential.user!.uid,
          );
          emailController.clear();
          passwordController.clear();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          });
          print('user logged in ${state.credential.user!.email}');
        }
        return Scaffold(
          backgroundColor: Colors.white,
          // resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Image.asset(
                "images/login_header.png",
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * .25,
                        ),
                        const Text(
                          'Welcome back!',
                          style: TextStyle(
                              fontSize: 27,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                        Container(
                          height: 60,
                          margin: EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3598DB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              _viewmodel.loginUser(emailController.text,
                                  passwordController.text);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Login',
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
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegisterScreen.routeName);
                            },
                            child: Text(
                              'Or Create My Account',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        // Scaffold(
        //   backgroundColor: Colors.white,
        //   // resizeToAvoidBottomInset: false,
        //   body: Container(
        //     decoration: const BoxDecoration(
        //       image: DecorationImage(
        //         image: AssetImage('images/login_header.png'),
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //     child: SafeArea(
        //       child: Padding(
        //         padding: const EdgeInsets.all(15.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             const Center(
        //               child: Text(
        //                 'Login',
        //                 style: TextStyle(
        //                     fontSize: 30,
        //                     color: Colors.white,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //             SizedBox(
        //               height: MediaQuery.sizeOf(context).height * .25,
        //             ),
        //             const Text(
        //               'Welcome back!',
        //               style: TextStyle(
        //                   fontSize: 27,
        //                   color: Colors.black,
        //                   fontWeight: FontWeight.bold),
        //             ),
        //             Container(
        //               margin: EdgeInsets.only(top: 15),
        //               child: Form(
        //                 child: Column(
        //                   children: [
        //                     TextFormField(
        //                       controller: emailController,
        //                       decoration: InputDecoration(
        //                         labelText: 'Email',
        //                         border: const UnderlineInputBorder(
        //                           borderSide: BorderSide(color: Colors.white),
        //                         ),
        //                         enabledBorder: UnderlineInputBorder(
        //                           borderSide:
        //                               BorderSide(color: Colors.grey[300]!),
        //                         ),
        //                       ),
        //                     ),
        //                     Container(
        //                       margin: EdgeInsets.only(top: 25),
        //                     ),
        //                     TextFormField(
        //                       controller: passwordController,
        //                       keyboardType: TextInputType.number,
        //                       obscureText: true,
        //                       decoration: InputDecoration(
        //                         labelText: 'Password',
        //                         border: const UnderlineInputBorder(
        //                           borderSide: BorderSide(color: Colors.white),
        //                         ),
        //                         enabledBorder: UnderlineInputBorder(
        //                           borderSide:
        //                               BorderSide(color: Colors.grey[300]!),
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             Container(
        //               height: 60,
        //               margin: EdgeInsets.only(top: 30),
        //               child: ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                   backgroundColor: const Color(0xFF3598DB),
        //                   shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(10),
        //                   ),
        //                 ),
        //                 onPressed: () {
        //                   _viewmodel.loginUser(
        //                       emailController.text, passwordController.text);
        //                 },
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(10.0),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       const Text(
        //                         'Login',
        //                         style: TextStyle(
        //                             fontSize: 17,
        //                             color: Colors.white,
        //                             fontWeight: FontWeight.bold),
        //                       ),
        //                       Image.asset('images/arrow_right.png')
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             Container(
        //               margin: EdgeInsets.only(top: 20),
        //               child: TextButton(
        //                 onPressed: () {
        //                   Navigator.pushNamed(
        //                       context, RegisterScreen.routeName);
        //                 },
        //                 child: Text(
        //                   'Or Create My Account',
        //                   style: TextStyle(
        //                       fontSize: 17,
        //                       color: Colors.grey[600],
        //                       fontWeight: FontWeight.w600),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }
}
