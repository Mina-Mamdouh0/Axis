
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/components/authentication_button.dart';
import 'package:inverntry/components/custom_text_field.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/models/product_model.dart';
import 'package:inverntry/screens/user/home_user_screen.dart';
import 'package:http/http.dart'as http;

class ConfirmScreen extends StatefulWidget {
  final int quantity;
  final ProductModel productModel;
   ConfirmScreen({Key? key, required this.productModel, required this.quantity,}) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final TextEditingController massageController=TextEditingController();
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? mtoken = " ";
  @override
  void initState() {
    super.initState();

    requestPermission();

    loadFCM();

    listenFCM();

    getToken();

    FirebaseMessaging.instance.subscribeToTopic("Animal");
  }
  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAABmMm-i8:APA91bHGOtBsNVkOGP2c0PFG6n8-WL2aYLBZKyT4ZQC_syUOjLqCehqAgnCSY6Nvsfx9dji8e2Jr3NEnCTPLa61BzGV__QtdarO_m_FSkXS5l6wn1dKmohgL_Lk301kl1xBijksXxv6R',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
  void getToken() async {
    await FirebaseFirestore.instance.collection("UserTokens").doc(widget.productModel.idAdminCreated.toString()).get()
        .then((value){
      setState(() {
        mtoken = value.get('token');
      });
        });
  }

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


  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }
  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future sendEmail({
  required String email,
  required String name,
  required String msg,
}) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = "service_hucikt6";
    const templateId = "template_1ipyybf";
    const userId = "XdZXieFyCcRFeexjl";
    final response = await http.post(url,
        headers: {'origin': '<http://localhost>',
          'Content-Type': 'application/json'},//This line makes sure it works for all platforms.
        body: json.encode({
          "service_id": serviceId,
          "template_id": templateId,
          "user_id": userId,
          "template_params": {
            "name": name,
            "user_email": email,
            "message": msg,
            "subject" : 'Axis Order',
          }
        }));
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kDarkGreenColor,
              elevation: 0.0,
              title: const Text('Confirm in  Product'),
            ),
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  CustomTextField(
                    controller: massageController,
                    hintText: 'Massage Order',
                    icon: Icons.description,
                    mixLines: 6,
                    obscureText: false,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 20,),
                  (state is LoadingAddOrder)?
                      const Center(child: CircularProgressIndicator(),)
                  :AuthenticationButton(
                    onPressed: (){
                     if(massageController.text.isNotEmpty){
                       cubit.uploadOrder(
                         nameUser: cubit.userModel!.name,
                           urlImage: widget.productModel.urlImage,
                           idProduct: widget.productModel.idProduct,
                           uIdProduct: widget.productModel.id,
                           nameProduct: widget.productModel.name,
                           massageOrder: massageController.text,
                           allQuantityProduct: widget.productModel.quantity,
                           idAdminCreatedProduct: widget.productModel.idAdminCreated,
                           quantityProduct: widget.quantity.toString());
                     }else{
                       Fluttertoast.showToast(msg: 'Write Massage');
                     }
                    },
                    label: 'Confirm',
                  )

                ],
              ),
            ),
          );
        },
        listener: (context,state)async{
          if(state is SuccessAddOrder){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeUserScreen()));
            BlocProvider.of<AppCubit>(context).getOrdersUser();
            BlocProvider.of<AppCubit>(context).getOrdersAdmin();
            BlocProvider.of<AppCubit>(context).getDateProduct();
            BlocProvider.of<AppCubit>(context).getProductByFolder(nameFolder: widget.productModel.nameFolder);
            BlocProvider.of<AppCubit>(context).getProductByFolderHideUser(nameFolder: widget.productModel.nameFolder);
            sendPushMessage(mtoken!, ' Order by ${BlocProvider.of<AppCubit>(context).userModel!.name} email :${BlocProvider.of<AppCubit>(context).userModel!.email} Order is :${widget.productModel.name} -- ${widget.quantity}','Order Product', );

            sendEmail(email: BlocProvider.of<AppCubit>(context).userModel!.email, name: BlocProvider.of<AppCubit>(context).userModel!.name, msg: 'Order is :${widget.productModel.name} -- ${widget.quantity}');

          }else if (state is ErrorAddFolder){
            Fluttertoast.showToast(msg: 'Order Not Created');
          }
        });
  }
}
