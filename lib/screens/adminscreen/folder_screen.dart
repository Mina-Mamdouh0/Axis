
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/screens/adminscreen/add_folder.dart';
import 'package:inverntry/screens/adminscreen/history_admin_screen.dart';
import 'package:inverntry/screens/adminscreen/products_admin_screen.dart';
import 'package:inverntry/screens/auth/login_screen.dart';

class FolderScreen extends StatelessWidget {
   FolderScreen({Key? key}) : super(key: key);

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
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              title: const Text('Admin User'),
              actions: [
                IconButton(
                  color: Colors.white,
                  splashRadius: 28.0,
                  icon: const Icon(
                    Icons.history,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryAdminScreen()));
                  },
                ),
                IconButton(
                    onPressed: (){
                      cubit.signOut();
                    },
                    icon: const Icon(Icons.login))
              ],
            ),
            body: cubit.folderList.isEmpty?
            const Center(child: Text('Empty Data',style: TextStyle(fontSize: 20)),):
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: ()async{
                  cubit.getFolders();
                },
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 200,
                    ),
                    itemCount: cubit.folderList.length,
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          BlocProvider.of<AppCubit>(context).getProductByFolder(nameFolder: cubit.folderList[index].nameFolder);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductsAdminScreen(nameFolder: cubit.folderList[index].nameFolder,idFolder: cubit.folderList[index].idFolder,)));
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
                                    child: Image.network(cubit.folderList[index].urlImage,
                                    fit: BoxFit.fill),
                                  )),
                              const SizedBox(height: 5,),
                              Text(cubit.folderList[index].nameFolder,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22
                                ),)
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFolder()));
                },
                backgroundColor: kDarkGreenColor,
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload,),
                    SizedBox(width: 5,),
                    Text('Create Folder')
                  ],
                )),

          );
        },
        listener: (context, state){
          if(state is SignOutState){
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          }
        });
  }
}
