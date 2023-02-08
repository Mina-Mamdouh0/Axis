
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/constants.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kDarkGreenColor,
              elevation: 0.0,
              title: const Text('History'),
            ),
            body: cubit.ordersUserList.isEmpty?
            const Center(child: Text('History Empty'),):
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: RefreshIndicator(
                onRefresh: ()async{
                  cubit.getOrdersUser();
                },
                child: ListView.builder(
                    itemCount: cubit.ordersUserList.length,
                    itemBuilder: (context,index){
                      return Container(
                        height: 175.0,
                        decoration: BoxDecoration(
                          color: kGinColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                           mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 80.0,
                                  width: 80.0,
                                  margin: const EdgeInsets.only(right: 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: NetworkImage(cubit.ordersUserList[index].urlImageProduct),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // The First Widget
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(cubit.ordersUserList[index].nameProduct,
                                            style: GoogleFonts.poppins(
                                              color: kDarkGreenColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // The info about the plant
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 6.0),
                                        child: Text(cubit.ordersUserList[index].quantityProduct,
                                          style: GoogleFonts.poppins(
                                            color: kGreyColor,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 6.0),
                                        child: Text(cubit.ordersUserList[index].createAt,
                                          style: GoogleFonts.poppins(
                                            color: kGreyColor,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            (cubit.ordersUserList[index].confirmThree)?
                            Text('Received',
                              style: GoogleFonts.poppins(
                                color: kDarkGreenColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ):Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: cubit.ordersUserList[index].confirmOne ?
                                        BoxDecoration(
                                            color: kDarkGreenColor, borderRadius: BorderRadius.circular(50))
                                            :BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            '1',
                                            style: TextStyle(color: cubit.ordersUserList[index].confirmOne?Colors.white:Colors.grey),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: kDarkGreenColor,
                                        height: 1,
                                        width: 70,
                                      ),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: cubit.ordersUserList[index].confirmTwo ?
                                        BoxDecoration(
                                            color: kDarkGreenColor, borderRadius: BorderRadius.circular(50))
                                            :BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            '2',
                                            style: TextStyle(color: cubit.ordersUserList[index].confirmTwo?Colors.white:Colors.grey),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: kDarkGreenColor,
                                        height: 1,
                                        width: 70,
                                      ),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: cubit.ordersUserList[index].confirmThree ?
                                        BoxDecoration(
                                            color: kDarkGreenColor, borderRadius: BorderRadius.circular(50))
                                            :BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            '3',
                                            style: TextStyle(color: cubit.ordersUserList[index].confirmThree?Colors.white:Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ]),
                                const SizedBox(width: 30,),
                                cubit.ordersUserList[index].confirmTwo?
                                IconButton(
                                    onPressed: (){
                                      cubit.confirmStepThree(idProduct: cubit.ordersUserList[index].idProduct, idOrder: cubit.ordersUserList[index].idOrder);
                                    },
                                    icon: Icon(Icons.qr_code_scanner,color: kDarkGreenColor,size: 40,)):Container(),
                              ],
                            )

                          ],
                        ),
                      );
                    }),
              ),
            ),
          );
        }, listener: (context,state){
      if(state is SuccessConfirmThreeState){
        BlocProvider.of<AppCubit>(context).getOrdersAdmin();
        BlocProvider.of<AppCubit>(context).getOrdersUser();
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Success Scan');
      }else if(state is ErrorConfirmThreeState){
        Fluttertoast.showToast(msg: 'Error Scan');
      }
    });
  }
}
