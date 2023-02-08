
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/components/authentication_button.dart';
import 'package:inverntry/components/custom_text_field.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/screens/adminscreen/add_product.dart';
import 'package:inverntry/screens/adminscreen/details_admin_screen.dart';

class ProductsAdminScreen extends StatelessWidget {
  final String nameFolder;
  final String idFolder;
  ProductsAdminScreen({Key? key, required this.nameFolder, required this.idFolder}) : super(key: key);

  TextEditingController password=TextEditingController();

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
              title: Text(nameFolder),
              actions: [
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
                                    Text('Delete Folder',style: TextStyle(color: Colors.red),),
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
                                            cubit.deleteFolder(idFolder: idFolder, nameFolder: nameFolder);
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
                    icon:const Icon(Icons.delete,color: Colors.red,)),
              ],
            ),
            body: cubit.productByFolder.isEmpty?
            const Center(child: Text('Empty Data',style: TextStyle(fontSize: 20)),):
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: ()async{
                  cubit.getProductByFolder(nameFolder: nameFolder);
                },
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 200,
                    ),
                    itemCount: cubit.productByFolder.length,
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductAdminDetails(productModel:cubit.productByFolder[index],
                          nameFolder: nameFolder,)));
                        },
                        child: Container(
                          height: 200,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: kSpiritedGreen,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(cubit.productByFolder[index].urlImage,
                                        fit: BoxFit.fill),
                                  )),
                              const SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(cubit.productByFolder[index].name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22
                                    ),),
                                  Text(cubit.productByFolder[index].quantity,
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProduct(nameFolder:nameFolder,)));
                },
                backgroundColor: kDarkGreenColor,
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload,),
                    SizedBox(width: 5,),
                    Text('Add Product')
                  ],
                )),

          );
        },
        listener: (context, state){
          if(state is SuccessDeleteFolder){
            BlocProvider.of<AppCubit>(context).getFolders();
            Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Folder Deleted');
          }else if(state is ErrorDeleteFolder){
            Fluttertoast.showToast(msg: 'Folder not Deleted');
          }

        });
  }
}