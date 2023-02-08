
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/screens/adminscreen/folder_screen.dart';
import 'package:inverntry/screens/auth/login_screen.dart';
import 'package:inverntry/screens/user/home_user_screen.dart';
import 'package:lottie/lottie.dart';
import '../bloc/app_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context,state){
          return Scaffold(
            backgroundColor: kDarkGreenColor,
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Lottie.asset('images/2888-assets-icon.json'),
                  const Spacer(),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 40,),
                ],
              ),
            ),
          );
        },
        listener: (context,state)async{
          if(FirebaseAuth.instance.currentUser==null){
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
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
        });
  }
}
