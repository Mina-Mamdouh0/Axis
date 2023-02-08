import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/components/authentication_button.dart';
import 'package:inverntry/components/curve.dart';
import 'package:inverntry/components/custom_text_field.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/screens/adminscreen/folder_screen.dart';
import 'package:inverntry/screens/user/home_user_screen.dart';
import 'package:inverntry/screens/auth/signup_screen.dart';
import 'package:http/http.dart'as http;


class LoginScreen extends StatelessWidget {

  bool rememberMe = false;
  static const String id = 'LoginScreen';
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();



  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          var cubit=AppCubit.get(context);
          return Material(
            child: Stack(
              alignment: Alignment.bottomRight,
              fit: StackFit.expand,
              children: [
                // First Child in the stack
                ClipPath(
                  clipper: ImageClipper(),
                  child: Image.asset(
                    'images/logo.jpeg',
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width,
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.67,
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // First Column
                            Text(
                              'Welcome Back',
                              style: GoogleFonts.poppins(
                                fontSize: 32.0,
                                fontWeight: FontWeight.w600,
                                color: kDarkGreenColor,
                              ),
                            ),
                            Text(
                              'Login to your account',
                              style: GoogleFonts.poppins(
                                color: kGreyColor,
                                fontSize: 15.0,
                              ),
                            ),
                            // Second Column
                            Column(
                              children: [
                                CustomTextField(
                                  mixLines: 1,
                                  controller: emailController,
                                  hintText: 'Username',
                                  icon: Icons.person,
                                  keyboardType: TextInputType.name,
                                ),
                                CustomTextField(
                                  mixLines: 1,
                                  controller: passwordController,
                                  hintText: 'Password',
                                  icon: Icons.lock,
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                        value: cubit.isCheckBox,
                                        onChanged: (value){
                                          cubit.changeCheckBox(value!);
                                        }),
                                    const SizedBox(width: 5,),
                                    Expanded(child: Text('Remember User and Password'))
                                  ],
                                ),
                              ],
                            ),

                            // Third Column
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  (state is LoadingLoginScreen || state is LoadingGetDataUser)?
                                      const Center(child: CircularProgressIndicator(),)
                                          : AuthenticationButton(
                                    label: 'Log In',
                                    onPressed: () {
                                      if (emailController.text.isNotEmpty&&passwordController.text.isNotEmpty) {
                                        cubit.userLogin(email: emailController.text,
                                            password: passwordController.text);
                                      }else{
                                        Fluttertoast.showToast(msg: 'Full Data or check remember');
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Don\'t have an account ?',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                            MaterialStateProperty.all(
                                                kDarkGreenColor),
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, SignupScreen.id);
                                          },
                                          child: const Text(
                                            'Sign up',
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        listener: (context, state)async{
          if(state is SuccessLoginScreen){
            BlocProvider.of<AppCubit>(context).getDateUser();
            requestPermission();
          }
          if(state is SuccessGetDataUser){
            if(BlocProvider.of<AppCubit>(context).userModel!.typeAccount=='Client'){
              Navigator.pushReplacementNamed(context, HomeUserScreen.id);
              BlocProvider.of<AppCubit>(context).getOrdersUser();

              await FirebaseMessaging.instance.getToken().then(
                      (token)async {
                    await FirebaseFirestore.instance.collection("UserTokens").doc(FirebaseAuth.instance.currentUser!.uid).set({
                      'token' : token,
                    });
                  }
              );
            }else{
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>FolderScreen()));
              BlocProvider.of<AppCubit>(context).getOrdersAdmin();

              await FirebaseMessaging.instance.getToken().then(
                      (token)async {
                    await FirebaseFirestore.instance.collection("UserTokens").doc(FirebaseAuth.instance.currentUser!.uid).set({
                      'token' : token,
                    });
                  }
              );
            }
          }
          if(state is ErrorLoginScreen){
            Fluttertoast.showToast(msg: 'Check Data');
          }

        });
  }
}
