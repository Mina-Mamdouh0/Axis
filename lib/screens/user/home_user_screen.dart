
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/components/curve.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/screens/auth/login_screen.dart';
import 'package:inverntry/screens/user/history_screen.dart';
import 'package:inverntry/screens/user/product_details_screen.dart';
import 'package:inverntry/screens/user/search_screen.dart';
import 'package:inverntry/screens/user/show_product_user.dart';

class HomeUserScreen extends StatelessWidget {
  const HomeUserScreen({Key? key}) : super(key: key);

  static const String id = 'HomeUserScreen';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: kDarkGreenColor,
                      radius: 22.0,
                      child: Center(
                        child: IconButton(
                          color: Colors.white,
                          splashRadius: 28.0,
                          icon: const Icon(
                            Icons.history,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryScreen()));
                          },
                        ),
                      ),

                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: kDarkGreenColor,
                      radius: 22.0,
                      child: Center(
                        child: IconButton(
                          color: Colors.white,
                          splashRadius: 28.0,
                          icon: const Icon(
                            Icons.refresh,
                          ),
                          onPressed: () {
                            cubit.getFolders();
                          },
                        ),
                      ),

                    ),
                    const SizedBox(width: 10,),
                    CircleAvatar(
                      backgroundColor: kDarkGreenColor,
                      radius: 22.0,
                      child: Center(
                        child: IconButton(
                          color: Colors.white,
                          splashRadius: 28.0,
                          icon: const Icon(
                            Icons.login,
                          ),
                          onPressed: () {
                            cubit.signOut();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          'Welcome in\n Axis!',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            color: kDarkGreenColor,
                            fontSize: 32.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      style: TextStyle(color: kDarkGreenColor),
                      cursorColor: kDarkGreenColor,
                      readOnly: true,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kGinColor,
                        hintText: 'Search Product',
                        hintStyle: TextStyle(color: kGreyColor),
                        prefixIcon: Icon(
                          Icons.search,
                          color: kDarkGreenColor,
                          size: 26.0,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: kGinColor),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kGinColor),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kGinColor),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50,),
                    cubit.folderList.isEmpty?
                    const Center(child: CircularProgressIndicator(),):
                    Expanded(
                      child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 50,
                            mainAxisExtent: 200,
                          ),
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 40),
                          itemCount: cubit.folderList.length,
                          itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                BlocProvider.of<AppCubit>(context).getProductByFolderHideUser(nameFolder: cubit.folderList[index].nameFolder);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductsUserScreen(nameFolder: cubit.folderList[index].nameFolder,)));
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 220.0,
                                    width: 185.0,
                                    decoration: BoxDecoration(
                                      color: kGinColor,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: CustomPaint(
                                      painter: CurvePainter(),
                                    ),
                                  ),
                                  Positioned(
                                    // height: 240.0,
                                    // width: 124.0,
                                    left: 8.0,
                                    bottom: 70.0,
                                    child: Container(
                                      constraints:
                                      const BoxConstraints(maxWidth: 124.0, maxHeight: 240.0),
                                      child: Hero(tag: cubit.folderList[index].nameFolder, child: Image.network(cubit.folderList[index].urlImage)),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    child: Container(
                                      width: 185,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cubit.folderList[index].nameFolder,
                                                    style: TextStyle(
                                                      color: kDarkGreenColor,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2.0),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),

            ),
          );
        },
        listener: (context,state){
          if(state is SignOutState){
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          }
        });
  }
}

