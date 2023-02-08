import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/components/authentication_button.dart';
import 'package:inverntry/components/custom_text_field.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/models/product_model.dart';
import 'package:inverntry/screens/adminscreen/update_product_screen.dart';

class ProductAdminDetails extends StatelessWidget {
   ProductAdminDetails({required this.productModel, Key? key, required this.nameFolder}) : super(key: key);

  final ProductModel productModel;
  final String nameFolder;
  TextEditingController password=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leadingWidth: 0.0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
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
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.42,
                    color: kSpiritedGreen,
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Hero(
                      tag: productModel.name,
                      child: Image.network(productModel.urlImage),
                    ),
                  ),
                  Container(
                    color: kSpiritedGreen,
                    //height: MediaQuery.of(context).size.height * 0.58,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                      ),
                      padding:
                      const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productModel.name,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              color: kDarkGreenColor,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              Text(productModel.quantity,
                                style: TextStyle(
                                  color: Colors.green.shade600,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              StarRating(
                                stars: 5,
                                size: 16.0,
                                onChanged: (value) {},
                              )
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Location : ',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                productModel.location,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: kDarkGreenColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Status : ',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                productModel.status,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: kDarkGreenColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Quantity : ',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                productModel.quantity,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: kDarkGreenColor,
                                ),
                              ),

                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'About',
                                  style: GoogleFonts.poppins(
                                    color: kDarkGreenColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 20.0),
                                  child: SingleChildScrollView(
                                    child: Text(productModel.desc,
                                      style: GoogleFonts.poppins(
                                        color: kDarkGreenColor,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Row(
                            children: [
                              (state is LoadingDeleteProduct)?
                              const Center(child: CircularProgressIndicator(),):
                              IconButton(
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            content: Container(
                                              width: 500,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('Delete Product',style: TextStyle(color: Colors.red),),
                                                  const SizedBox(height: 5,),
                                                  CustomTextField(
                                                      hintText: 'Password',
                                                      icon: Icons.lock,
                                                      mixLines: 1,
                                                      controller: password,
                                                      keyboardType: TextInputType.text),
                                                  const SizedBox(height: 5,),
                                                  (state is LoadingDeleteFolder)?
                                                  const Center(child: CircularProgressIndicator(),)
                                                      :AuthenticationButton(
                                                    onPressed: (){
                                                      if(password.text.isNotEmpty){
                                                        if(password.text==cubit.userModel!.password){
                                                          cubit.deleteProduct(idProduct: productModel.id);
                                                        }
                                                      }
                                                      else{
                                                        Navigator.of(context).pop();
                                                      }
                                                    },
                                                    label: 'Delete',
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });

                                  },
                                  icon: const Icon(Icons.delete,color: Colors.red,)),
                              const SizedBox(width: 5,),
                              Expanded(child: AuthenticationButton(
                                  label: 'Edit Product',
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProductScreen(productModel: productModel,nameFolder: nameFolder,)));
                                  }
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
    },
        listener: (context,state){
          if(state is SuccessDeleteProduct){
            BlocProvider.of<AppCubit>(context).getProductByFolder(nameFolder: nameFolder);
            BlocProvider.of<AppCubit>(context).getProductByFolderHideUser(nameFolder: nameFolder);
            Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Product Deleted');
          }else if(state is ErrorDeleteProduct){
            Fluttertoast.showToast(msg: 'Product not Deleted');
          }
        });
  }
}

class StarRating extends StatelessWidget {
  final int scale;
  final double stars;
  final Color? color;
  final double? size;
  final Function(double)? onChanged;

  const StarRating({
    this.scale = 5,
    this.stars = 0.0,
    this.size,
    this.color = Colors.orange,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  Widget buildStar(BuildContext context, int index) {
    IconData icon;
    if (index >= stars) {
      icon = Icons.star_border;
    } else if (index > stars - 1 && index < stars) {
      icon = Icons.star_half;
    } else {
      icon = Icons.star;
    }
    return GestureDetector(
      onTap: () => onChanged!(index + 1.0),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        scale,
            (index) => buildStar(context, index),
      ),
    );
  }
}