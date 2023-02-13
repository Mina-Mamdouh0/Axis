
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/components/authentication_button.dart';
import 'package:inverntry/components/custom_text_field.dart';
import 'package:inverntry/components/show_dialog.dart';
import 'package:inverntry/constants.dart';

class AddProduct extends StatelessWidget {
  final String nameFolder;
   AddProduct({Key? key, required this.nameFolder}) : super(key: key);

   final TextEditingController nameController=TextEditingController();
   final TextEditingController descController=TextEditingController();
   final TextEditingController quantityController=TextEditingController();
   final TextEditingController expTimeController=TextEditingController();
   final TextEditingController locationController=TextEditingController();
   final TextEditingController statuesController=TextEditingController();


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
              title: const Text('Add Product'),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                    controller: nameController,
                    hintText: 'Name Product',
                    icon: Icons.title,
                    obscureText: false,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextField(
                          mixLines: 1,
                          readOnly: true,
                          controller: cubit.idProductController,
                          hintText: 'Id Product',
                          icon: Icons.key,
                          obscureText: false,
                          keyboardType: TextInputType.visiblePassword,
                        ),),
                        IconButton(
                            onPressed: (){
                              cubit.scanQr();
                            },
                            icon: Icon(Icons.qr_code_scanner,color: kDarkGreenColor,size: 40,)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    mixLines: 1,
                    controller: quantityController,
                    hintText: 'Quantity',
                    icon: Icons.high_quality,
                    obscureText: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.deny(RegExp(r'^0+(?=.)')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    mixLines: 1,
                    controller: expTimeController,
                    hintText: 'Exp Time',
                    icon: Icons.more_time,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    onTap: (){
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100)).then((value){
                        if(value!=null) {
                          expTimeController.text = '${value.year}-${value.month}-${value.day}';
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    mixLines: 1,
                    controller: locationController,
                    hintText: 'Location',
                    icon: Icons.location_on_outlined,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    mixLines: 1,
                    controller: statuesController,
                    hintText: 'Statues',
                    icon: Icons.multiple_stop_sharp,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    controller: descController,
                    hintText: 'About',
                    icon: Icons.description,
                    mixLines: 6,
                    obscureText: false,
                    keyboardType: TextInputType.visiblePassword,
                  ),

                  const SizedBox(height: 10,),
                  (state is LoadingAddProduct )?
                  const Center(child: CircularProgressIndicator(),)
                      : AuthenticationButton(
                    label: 'Update Product',
                    onPressed: () {
                      if (nameController.text.isNotEmpty&&cubit.idProductController.text.isNotEmpty
                      &&quantityController.text.isNotEmpty&&expTimeController.text.isNotEmpty
                          &&locationController.text.isNotEmpty
                      &&descController.text.isNotEmpty&&statuesController.text.isNotEmpty) {
                        cubit.uploadProduct(
                          status: statuesController.text,
                            location: locationController.text,
                            name: nameController.text,
                            desc: descController.text,
                            nameFolder: nameFolder,
                            expTime: expTimeController.text,
                            idProduct: cubit.idProductController.text,
                            quantity: quantityController.text
                        );
                      }
                      else{
                        Fluttertoast.showToast(msg: 'Full data');
                      }
                    },
                  ),
                  const SizedBox(height: 20,),


                ],
              ),
            ),

          );
        },
        listener: (context, state){
          if(state is SuccessAddProduct){
            descController.clear();
            quantityController.clear();
            expTimeController.clear();
            locationController.clear();
            BlocProvider.of<AppCubit>(context).idProductController.clear();
            BlocProvider.of<AppCubit>(context).file=null;
            BlocProvider.of<AppCubit>(context).getProductByFolder(nameFolder: nameFolder);
            BlocProvider.of<AppCubit>(context).getProductByFolderHideUser(nameFolder: nameFolder);
            BlocProvider.of<AppCubit>(context).getDateProduct();
            nameController.clear();
            Navigator.pop(context);
          }else if(state is ErrorAddProduct){
            Fluttertoast.showToast(msg: 'Dont have Create The Product');
          }
        });
  }

}
