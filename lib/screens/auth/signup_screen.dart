import 'dart:convert';

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
import 'package:inverntry/screens/auth/login_screen.dart';
import 'package:http/http.dart'as http;


class SignupScreen extends StatelessWidget {
   SignupScreen({Key? key}) : super(key: key);

  static String id = 'SignupScreen';
  final TextEditingController nameController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController confirmPasswordController=TextEditingController();
   GlobalKey<FormState> kForm=GlobalKey<FormState>();
   List<String> typeAccountList=[
     'Client',
     'Admin'
   ];

   Future sendEmail() async {
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
             "name": '',
             "user_email": emailController.text,
             "message": 'Welcome To Axis',
             "subject" : '',
           }
         }));
     return response.statusCode;
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
                ClipPath(
                  clipper: ImageClipper(),
                  child: Image.asset(
                    'images/logo.jpeg',
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  height: MediaQuery.of(context).size.height * 0.83,
                  width: MediaQuery.of(context).size.width,
                  child: Scaffold(
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Form(
                            key: kForm,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Register',
                                      style: GoogleFonts.poppins(
                                        fontSize: 32.0,
                                        fontWeight: FontWeight.w600,
                                        color: kDarkGreenColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      'Create a new account',
                                      style: GoogleFonts.poppins(
                                        color: kGreyColor,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(height: 40.0),
                                    CustomTextField(
                                      mixLines: 1,
                                      controller: nameController,
                                      hintText: 'Full Name',
                                      icon: Icons.person,
                                      keyboardType: TextInputType.name,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                                      child: DropdownButtonFormField(
                                          isExpanded: true,
                                          dropdownColor: Colors.white,
                                          style: GoogleFonts.poppins(
                                            color: kDarkGreenColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.all(18.0),
                                            filled: true,
                                            fillColor: kGinColor,
                                            hintText: 'Type Account',
                                            hintStyle: GoogleFonts.poppins(
                                              color: kDarkGreenColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.0,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(color: kGinColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(color: kDarkGreenColor),
                                            ),
                                          ),

                                          items: [
                                            ...typeAccountList.map((e) {
                                              return DropdownMenuItem(
                                                onTap: (){
                                                },
                                                value: e,
                                                child: Text(e,
                                                  style:  const TextStyle(fontWeight: FontWeight.bold),),
                                              );
                                            }),
                                          ],
                                          value: cubit.typeAccount,
                                          onChanged: (val){
                                            cubit.changeTypeAccount(account: val.toString());
                                            //typeAccount=val.toString();
                                          }
                                      ),
                                    ),
                                    cubit.typeAccount==null?
                                    Container():
                                    Column(
                                      children: [
                                        /*cubit.typeAccount=='Client'?
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                                          child: TextFormField(
                                            controller: emailController,
                                            cursorColor: kDarkGreenColor,
                                            validator: (value){
                                              if(value!.isEmpty || !value.contains('@gmail.com')){
                                                return 'Check The Email';
                                              }
                                            },
                                            keyboardType: TextInputType.emailAddress,
                                            style: GoogleFonts.poppins(
                                              color: kDarkGreenColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.0,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(18.0),
                                              filled: true,
                                              fillColor: kGinColor,
                                              prefixIcon: Icon(
                                                Icons.email,
                                                size: 24.0,
                                                color: kDarkGreenColor,
                                              ),
                                              hintText: 'User email',
                                              hintStyle: GoogleFonts.poppins(
                                                color: kDarkGreenColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: kGinColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: kDarkGreenColor),
                                              ),
                                            ),
                                          ),
                                        ):*/
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                                          child: TextFormField(
                                            controller: emailController,
                                            cursorColor: kDarkGreenColor,
                                            validator: (value){
                                              if(value!.isEmpty || (!value.contains('@marayasocial.com')
                                                  && !value.contains('@chickenrepublic.com')
                                                  && !value.contains('@ambassadoroffood.com')
                                                  && !value.contains('@axis.hospitality.com')
                                                  && !value.contains('@radicaifood.com')
                                                  && !value.contains('@arabianphoenix.com')
                                                  && !value.contains('@zangalounge.com.sa')
                                                  && !value.contains('@marshmallow.sa')
                                                  && !value.contains('@daralabbar.com')
                                                  && !value.contains('@emecoksa.com')
                                              )){
                                                return 'Check The Email';
                                              }
                                            },
                                            keyboardType: TextInputType.emailAddress,
                                            style: GoogleFonts.poppins(
                                              color: kDarkGreenColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.0,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(18.0),
                                              filled: true,
                                              fillColor: kGinColor,
                                              prefixIcon: Icon(
                                                Icons.email,
                                                size: 24.0,
                                                color: kDarkGreenColor,
                                              ),
                                              hintText: 'email',
                                              hintStyle: GoogleFonts.poppins(
                                                color: kDarkGreenColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: kGinColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: kDarkGreenColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                        CustomTextField(
                                          mixLines: 1,
                                          controller: passwordController,
                                          hintText: 'Password',
                                          icon: Icons.lock,
                                          keyboardType: TextInputType.name,
                                        ),
                                      ],
                                    ),




                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'By signing you agree to our ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                            color: kDarkGreenColor,
                                          ),
                                        ),
                                        Text(
                                          ' Terms of use',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                            color: kGreyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'and ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                            color: kDarkGreenColor,
                                          ),
                                        ),
                                        Text(
                                          ' privacy notice',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                            color: kGreyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                                (state is LoadingSignUpScreen)?
                                const Center(child: CircularProgressIndicator(),):
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: AuthenticationButton(
                                    label: 'Sign Up',
                                    onPressed: () {
                                      if(cubit.typeAccount!=null){
                                          if(kForm.currentState!.validate()
                                              &&passwordController.text.isNotEmpty
                                              &&nameController.text.isNotEmpty){
                                            cubit.userSignUp(
                                                email: emailController.text,
                                                password: passwordController.text,
                                                name: nameController.text,
                                                typeAccount: cubit.typeAccount!);
                                        }
                                      }else{
                                        Fluttertoast.showToast(msg: 'Check in Type Account');
                                      }

                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30.0,
                  left: 20.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    radius: 20.0,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: kDarkGreenColor,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        listener: (context, state){
          if(state is SuccessSignUpScreen){
            Navigator.pushReplacementNamed(context, LoginScreen.id);
            sendEmail();
          }else if(state is ErrorSignUpScreen){
            Fluttertoast.showToast(msg: 'Check in Data');
          }

        });
  }
}
