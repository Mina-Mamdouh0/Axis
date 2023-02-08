
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/components/authentication_button.dart';
import 'package:inverntry/components/custom_text_field.dart';
import 'package:inverntry/components/show_dialog.dart';
import 'package:inverntry/constants.dart';

class AddFolder extends StatelessWidget {
  AddFolder({Key? key}) : super(key: key);

  final TextEditingController nameFolderController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          var cubit=AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: kDarkGreenColor,
              elevation: 0.0,
              title: const Text('Create Folder'),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin:const  EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.width*0.2,
                        width: MediaQuery.of(context).size.width*0.2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: cubit.file==null?Image.asset('images/logo.jpeg',
                            fit: BoxFit.fill,):Image.file(cubit.file!,
                            fit: BoxFit.fill,),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          showDialog(context: context,
                              builder: (context){
                                return show(context: context,
                                    camera: ()async{
                                      Navigator.pop(context);
                                      XFile? picked=await ImagePicker().pickImage(source: ImageSource.camera,maxHeight: 1080,maxWidth: 1080);
                                      if(picked !=null){
                                        cubit.changeImage(picked.path);
                                      }
                                    },
                                    gallery: ()async{
                                      Navigator.pop(context);
                                      XFile? picked=await ImagePicker().pickImage(source: ImageSource.gallery,maxHeight: 1080,maxWidth: 1080);
                                      if(picked !=null){
                                        cubit.changeImage(picked.path);
                                      }
                                    });
                              });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 2,
                                  color: Colors.white),
                              color: Colors.pink
                          ),
                          child: Icon(cubit.file==null?Icons.camera_alt:Icons.edit,
                            color: Colors.white,
                            size: 20,),

                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    mixLines: 1,
                    controller: nameFolderController,
                    hintText: 'Name Folder',
                    icon: Icons.title,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10,),
                  (state is LoadingAddFolder )?
                  const Center(child: CircularProgressIndicator(),)
                      : AuthenticationButton(
                    label: 'Update Folder',
                    onPressed: () {
                      if (nameFolderController.text.isNotEmpty) {
                        cubit.uploadFolder(nameFolder: nameFolderController.text);
                      }
                      else{
                        Fluttertoast.showToast(msg: 'Choose Name Folder ');
                      }
                    },
                  ),
                ],
              ),
            ),

          );
        },
        listener: (context, state){
          if(state is SuccessAddFolder){
            BlocProvider.of<AppCubit>(context).file=null;
            nameFolderController.clear();
            BlocProvider.of<AppCubit>(context).getFolders();
            Navigator.pop(context);
          }else if(state is ErrorAddFolder){
            Fluttertoast.showToast(msg: 'Dont have create Folder');
          }
        });
  }
}
