
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/components/curve.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/screens/user/product_details_screen.dart';

class ProductsUserScreen extends StatelessWidget {
  final String nameFolder;
  ProductsUserScreen({Key? key, required this.nameFolder,}) : super(key: key);

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
            ),
            body: cubit.productByFolderHideUser.isEmpty?
            const Center(child: Text('Empty Data',style: TextStyle(fontSize: 20)),):
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: ()async{
                  cubit.getProductByFolderHideUser(nameFolder: nameFolder);
                },
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 200,
                    ),
                    itemCount: cubit.productByFolderHideUser.length,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductUserDetails(productModel: cubit.productByFolderHideUser[index],)));
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
                                child: Hero(tag: cubit.productByFolderHideUser[index].name, child: Image.network(cubit.productByFolderHideUser[index].urlImage)),
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
                                              cubit.productByFolderHideUser[index].nameFolder,
                                              style: TextStyle(
                                                color: kDarkGreenColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 2.0),
                                            Expanded(
                                              child: Text(
                                                cubit.productByFolderHideUser[index].name,
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                softWrap: false,
                                                style: TextStyle(
                                                  color: kDarkGreenColor,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6.0,
                                          horizontal: 10.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: kFoamColor,
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        constraints: const BoxConstraints(maxWidth: 90.0),
                                        child: Text(
                                          '${cubit.productByFolderHideUser[index].quantity}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: kDarkGreenColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.8,
                                          ),
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
            ),

          );
        },
        listener: (context, state){});
  }
}