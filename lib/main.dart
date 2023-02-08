import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/firebase_options.dart';
import 'package:inverntry/screens/splash_screen.dart';
import 'package:inverntry/screens/user/home_user_screen.dart';
import 'package:inverntry/screens/auth/signup_screen.dart';
import 'screens/auth/login_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );

   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(BlocProvider(
      create: (_)=>AppCubit()..getDateUser()..getDateProduct()..getFolders(),
  child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Axis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const SplashScreen(),
      routes: {
        LoginScreen.id: (context) =>  LoginScreen(),
        SignupScreen.id: (context) =>  SignupScreen(),
        HomeUserScreen.id: (context) => const HomeUserScreen(),
        //CartScreen.id: (context) => const CartScreen(),
      },
    );
  }
}
