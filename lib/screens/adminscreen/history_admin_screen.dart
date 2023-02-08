import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/constants.dart';

class HistoryAdminScreen extends StatelessWidget {
  const HistoryAdminScreen({Key? key}) : super(key: key);

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
            body: cubit.ordersAdminList.isEmpty?
            const Center(child: Text('History Empty'),):

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: RefreshIndicator(
                onRefresh: ()async{
                  cubit.getOrdersAdmin();
                },
                child: ListView.builder(
                    itemCount: cubit.ordersAdminList.length,
                    itemBuilder: (context,index){
                      return Container(
                        height: 200.0,
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
                                      image: NetworkImage(cubit.ordersAdminList[index].urlImageProduct),
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
                                          Text(cubit.ordersAdminList[index].nameProduct,
                                            style: GoogleFonts.poppins(
                                              color: kDarkGreenColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              showDialog(context: context,
                                                  builder: (context){
                                                    return AlertDialog(
                                                      title:const  Text(
                                                        'Massage Order',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      content: SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              cubit.ordersAdminList[index].massageOrder,
                                                              style:const  TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(onPressed: (){
                                                          Navigator.pop(context);
                                                        }, child: const Text('Ok'))
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Icon(
                                              Icons.message,
                                              color: kDarkGreenColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Name User : ',
                                            style: GoogleFonts.poppins(
                                              color: kDarkGreenColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Text(cubit.ordersAdminList[index].nameUser,
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
                                        child: Text(cubit.ordersAdminList[index].quantityProduct,
                                          style: GoogleFonts.poppins(
                                            color: kGreyColor,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 6.0),
                                        child: Text(cubit.ordersAdminList[index].createAt,
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
                            cubit.ordersAdminList[index].confirmThree?
                            Text('Finished',
                              style: GoogleFonts.poppins(
                                color: kDarkGreenColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ):
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: cubit.ordersAdminList[index].confirmOne ?
                                        BoxDecoration(
                                            color: kDarkGreenColor, borderRadius: BorderRadius.circular(50))
                                            :BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            '1',
                                            style: TextStyle(color: cubit.ordersAdminList[index].confirmOne?Colors.white:Colors.grey),
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
                                        decoration: cubit.ordersAdminList[index].confirmTwo ?
                                        BoxDecoration(
                                            color: kDarkGreenColor, borderRadius: BorderRadius.circular(50))
                                            :BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            '2',
                                            style: TextStyle(color: cubit.ordersAdminList[index].confirmTwo?Colors.white:Colors.grey),
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
                                        decoration: cubit.ordersAdminList[index].confirmThree ?
                                        BoxDecoration(
                                            color: kDarkGreenColor, borderRadius: BorderRadius.circular(50))
                                            :BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            '3',
                                            style: TextStyle(color: cubit.ordersAdminList[index].confirmThree?Colors.white:Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ]),
                                const SizedBox(width: 30,),
                                (cubit.ordersAdminList[index].confirmTwo)?
                                    Container():
                                IconButton(
                                    onPressed: (){
                                      cubit.confirmStepTwo(idProduct: cubit.ordersAdminList[index].idProduct, idOrder: cubit.ordersAdminList[index].idOrder);
                                    },
                                    icon: Icon(Icons.qr_code_scanner,color: kDarkGreenColor,size: 40,))

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
          if(state is SuccessConfirmTwoState){
            BlocProvider.of<AppCubit>(context).getOrdersAdmin();
            BlocProvider.of<AppCubit>(context).getOrdersUser();
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Success Scan');
          }else if(state is ErrorConfirmTwoState){
            Fluttertoast.showToast(msg: 'Error Scan');
          }

    });
  }
}