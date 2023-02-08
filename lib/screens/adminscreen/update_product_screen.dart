

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
import 'package:inverntry/models/product_model.dart';

class UpdateProductScreen extends StatelessWidget {
  final ProductModel productModel;
  final String nameFolder;
  UpdateProductScreen({Key? key, required this.productModel, required this.nameFolder,}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController=TextEditingController(text: productModel.name);
    final TextEditingController descController=TextEditingController(text: productModel.desc);
    final TextEditingController quantityController=TextEditingController(text: productModel.quantity);
    final TextEditingController expTimeController=TextEditingController(text: productModel.expTime);
    final TextEditingController locationController=TextEditingController(text: productModel.location);
    String hide=productModel.hide;
    List<String> hideString=['true','false'];
    String status=productModel.status;
    List<String> statusList=[  'available', 'inAvailable',];
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          var cubit=AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: kDarkGreenColor,
              elevation: 0.0,
              title: const Text('Update Product'),
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
                    controller: descController,
                    hintText: 'About',
                    icon: Icons.description,
                    mixLines: 6,
                    obscureText: false,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    controller: locationController,
                    hintText: 'Location',
                    icon: Icons.location_on_outlined,
                    mixLines: 1,
                    obscureText: false,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                    child: DropdownButtonFormField(
                        items: [
                          ...hideString.map((e) {
                            return DropdownMenuItem(
                              child: Text(e),
                                value: e,
                            );
                          })
                        ],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(18.0),
                          filled: true,
                          fillColor: kGinColor,
                          hintText: 'Hide',
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
                        value: hide,
                        onChanged: (val){
                          hide=val!;
                        }),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                    child: DropdownButtonFormField(
                        items: [
                          ...statusList.map((e) {
                            return DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            );
                          })
                        ],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(18.0),
                          filled: true,
                          fillColor: kGinColor,
                          hintText: 'Stetus',
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
                        value: status,
                        onChanged: (val){
                          status=val!;
                        }),
                  ),
                  const SizedBox(height: 10,),
                  (state is LoadingUpdateProduct )?
                  const Center(child: CircularProgressIndicator(),)
                      : AuthenticationButton(
                    label: 'Update Product',
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&quantityController.text.isNotEmpty
                          &&expTimeController.text.isNotEmpty &&
                          descController.text.isNotEmpty
                          &&locationController.text.isNotEmpty &&status!=null&&hide!=null) {
                        cubit.updateProduct(
                          hide: hide,
                            location: locationController.text,
                            status: status,
                            name: nameController.text,
                            desc: descController.text,
                            expTime: expTimeController.text,
                            id: productModel.id,
                            quantity: quantityController.text
                        );
                      }
                      else{
                        Fluttertoast.showToast(msg: 'Full data');
                      }
                    },
                  ),
                ],
              ),
            ),

          );
        },
        listener: (context, state){
          if(state is SuccessUpdateProduct){
            descController.clear();
            quantityController.clear();
            expTimeController.clear();
            BlocProvider.of<AppCubit>(context).file=null;
            BlocProvider.of<AppCubit>(context).getProductByFolder(nameFolder: nameFolder);
            BlocProvider.of<AppCubit>(context).getProductByFolderHideUser(nameFolder: nameFolder);
            BlocProvider.of<AppCubit>(context).getDateProduct();
            nameController.clear();
            Navigator.pop(context);
            Navigator.pop(context);
          }else if(state is ErrorUpdateProduct){
            Fluttertoast.showToast(msg: 'Dont have Update The Product');
          }
        });
  }

}
