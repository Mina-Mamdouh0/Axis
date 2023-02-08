
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inverntry/bloc/app_cubit.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/components/curve.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/models/product_model.dart';
import 'package:inverntry/screens/user/product_details_screen.dart';



class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context,state){
          var cubit=AppCubit.get(context);
          List<ProductModel> searchProduct=cubit.searchProduct;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kDarkGreenColor,
              elevation: 0.0,
              title: const Text('Search Products'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(color: kDarkGreenColor),
                    cursorColor: kDarkGreenColor,
                    onChanged: (searchName) {
                      cubit.getSearchProduct(searchName);
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kGinColor,
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      )
                          : null,
                      hintText: "search",
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
                  Expanded(child: searchProduct.isNotEmpty?
                  GridView.builder(
                      padding: const EdgeInsets.only(top: 40),
                      itemCount: cubit.searchProduct.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) =>
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductUserDetails(productModel: searchProduct[index],)));
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
                                    child: Hero(tag: searchProduct[index].name, child: Image.network(searchProduct[index].urlImage)),
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
                                                  searchProduct[index].nameFolder,
                                                  style: TextStyle(
                                                    color: kDarkGreenColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                const SizedBox(height: 2.0),
                                                Expanded(
                                                  child: Text(
                                                    searchProduct[index].name,
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
                                              searchProduct[index].quantity,
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
                          )
                  ):
                  Center(
                    child: Text('Empty Product',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                            fontSize: 22
                        )),
                  )),
                ],
              ),
            )
            ,
          );
        },
        listener: (context, state){

        });
  }
}

