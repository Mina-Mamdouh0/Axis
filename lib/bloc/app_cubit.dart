import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inverntry/bloc/app_state.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/models/folder_model.dart';
import 'package:inverntry/models/order_model.dart';
import 'package:inverntry/models/product_model.dart';
import 'package:inverntry/models/user_model.dart';
import 'package:uuid/uuid.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(InitialState());

  static AppCubit get(context)=>BlocProvider.of(context);
  bool obscureText=true;
  bool isCheckBox=false;
  void userLogin({required String email, required String password,}){
    emit(LoadingLoginScreen());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).
    then((value){
      emit(SuccessLoginScreen());
    }).
    onError((error,_){
      emit(ErrorLoginScreen(error.toString()));
    });
  }

  void changeCheckBox(bool value){
    isCheckBox=value;
    emit(ChangeCheckBox());
  }

  void userSignUp({required String email, required String password, required String name, required String typeAccount,}){
    emit(LoadingSignUpScreen());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password).
    then((value){
      UserModel model=UserModel(
        name: name,
        typeAccount: typeAccount,
        email: email,
        uId: value.user!.uid,
      password:password,
      createAt: Timestamp.now());
      FirebaseFirestore.instance.collection('Users').doc(value.user!.uid).set(
          model.toMap()).then((value){
        emit(SuccessSignUpScreen());
      });
        }).onError((error,_){
      emit(ErrorSignUpScreen(error.toString()));
    });
  }

  String? typeAccount;
  void changeTypeAccount({required String account}){
    typeAccount=account;
    emit(ChangeTypeAccount());
  }

  UserModel ?userModel;
  Future<void> getDateUser()async{
    if(FirebaseAuth.instance.currentUser!=null){
      emit(LoadingGetDataUser());
      FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get()
          .then((value){
            userModel=UserModel.formJson(value.data()!);
            emit(SuccessGetDataUser());
      }).onError((error, stackTrace){
        emit(ErrorGetDataUser(error.toString()));
      });
    }
  }

  void signOut(){
    FirebaseAuth.instance.signOut().whenComplete(() {
      userModel=null;
      emit(SignOutState());
    });
  }

  File? file;
  void changeImage(String imagePath){
    file=File(imagePath);
    if(file!=null){
      emit(ChangeImageState());
    }
  }

  String? urlImageFolder;
  void uploadFolder({required String nameFolder})async{
    if(FirebaseAuth.instance.currentUser!=null) {
      emit(LoadingAddFolder());
      if(file!=null){
        final ref = FirebaseStorage.instance.ref().child('FolderImage').
        child(FirebaseAuth.instance.currentUser!.uid).
        child('${file!.path.split('/').last}.jpg');
        await ref.putFile(file!).then((p0) async {
          urlImageFolder = await ref.getDownloadURL();
        });
      }
    }
    String id=const Uuid().v4();
    FolderModel folderModel=FolderModel(
        idFolder: id,
        nameFolder: nameFolder,
        urlImage: urlImageFolder??imageUrl,
        createAt: Timestamp.now());
    FirebaseFirestore.instance.collection('Folders').doc(id)
        .set(folderModel.toMap()).then((value) {
      emit(SuccessAddFolder());
    }).onError((error, stackTrace){
      emit(ErrorAddFolder(error.toString()));
    });

  }

  List<FolderModel> folderList=[];
  void getFolders(){
    folderList.clear();
      emit(LoadingGetFolders());
      FirebaseFirestore.instance.collection('Folders').get()
          .then((value){
        for (var element in value.docs) {
          folderList.add(FolderModel.formJson(element.data()));
        }
        emit(SuccessGetFolders());
      }).onError((error, stackTrace) {
        emit(ErrorGetFolders(error.toString()));
      });

  }

  void deleteFolder({required String idFolder,required String nameFolder}){
    emit(LoadingDeleteFolder());
    FirebaseFirestore.instance.collection('Folders')
    .doc(idFolder).delete().then((value){
      FirebaseFirestore.instance.collection('Products')
          .where('NameFolder',isEqualTo: nameFolder).get().then((value){
            for (var element in value.docs) {
              FirebaseFirestore.instance.collection('Products').doc(element.id).delete();
            }
      }).then((value){
        emit(SuccessDeleteFolder());
      });
    }).onError((error, stackTrace){
      emit(ErrorDeleteFolder(error.toString()));
    });
    
  }

  final TextEditingController idProductController=TextEditingController();
  Future <void>scanQr()async{
    try{
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR).then((value){
        idProductController.text=value;
        emit(ChangeQRCode());
      });
    }catch(e){
      idProductController.text='';
      emit(ChangeQRCode());
    }
  }

  String? url;
  void uploadProduct({
  required String name,
  required String desc,
  required String nameFolder,
  required String idProduct,
  required String quantity,
  required String expTime,
  required String location,
  required String status,
})async{
    if(FirebaseAuth.instance.currentUser!=null) {
      emit(LoadingAddProduct());
      if(file!=null){
        final ref = FirebaseStorage.instance.ref().child('ProductImages').
        child(FirebaseAuth.instance.currentUser!.uid).
        child('${file!.path.split('/').last}.jpg');
        await ref.putFile(file!).then((p0) async {
          url = await ref.getDownloadURL();
        });
      }
    }
    String id=const Uuid().v4();
    ProductModel productModel=ProductModel(
        name: name,
        desc: desc,
        hide: 'false',
        location: location,
        status: status,
        id: id,
        idProduct: idProduct,
        nameFolder: nameFolder,
        urlImage: url??imageUrl,
        expTime: expTime,
        idAdminCreated: FirebaseAuth.instance.currentUser!.uid,
        quantity: quantity,
        createAt: Timestamp.now());
    FirebaseFirestore.instance.collection('Products').doc(id)
        .set(productModel.toMap()).then((value) {
      emit(SuccessAddProduct());
    }).onError((error, stackTrace){
      emit(ErrorAddProduct(error.toString()));
    });
}

  List<ProductModel> productByFolder=[];
  void getProductByFolder({required String nameFolder}){
    productByFolder=[];
    emit(LoadingGetProducts());
    FirebaseFirestore.instance.collection('Products').
    where('NameFolder',isEqualTo: nameFolder).get()
        .then((value){
      for (var element in value.docs) {
        productByFolder.add(ProductModel.formJson(element.data()));
      }
      emit(SuccessGetProducts());
    }).onError((error, stackTrace) {
      emit(ErrorGetProducts(error.toString()));
    });

  }

  List<ProductModel> productByFolderHideUser=[];
  void getProductByFolderHideUser({required String nameFolder}){
    productByFolderHideUser=[];
    emit(LoadingGetProductsHideUser());
    FirebaseFirestore.instance.collection('Products').
    where('NameFolder',isEqualTo: nameFolder).
    where('Hide',isEqualTo: 'false').
    get()
        .then((value){
      for (var element in value.docs) {
        productByFolderHideUser.add(ProductModel.formJson(element.data()));
      }
      emit(SuccessGetProductsHideUser());
    }).onError((error, stackTrace) {
      emit(ErrorGetProductsHideUser(error.toString()));
    });

  }

 List<ProductModel> productList=[];
 void getDateProduct(){
  productList=[];
  emit(LoadingGetProducts());
  FirebaseFirestore.instance.collection('Products').get()
  .then((value){
    for (var element in value.docs) {
      productList.add(ProductModel.formJson(element.data()));
    }
    emit(SuccessGetProducts());
  }).onError((error, stackTrace) {
    emit(ErrorGetProducts(error.toString()));
  });
}



void deleteProduct({required String idProduct}){
   emit(LoadingDeleteProduct());
   FirebaseFirestore.instance.collection('Products').doc(idProduct)
   .delete().then((value){
     emit(SuccessDeleteProduct());
   }).onError((error, stackTrace) {
     emit(ErrorDeleteProduct(error.toString()));
   });
}

void updateProduct({
  required String id,
  required String name,
  required String desc,
  required String quantity,
  required String expTime,
  required String hide,
  required String location,
  required String status,
})async{
  if(FirebaseAuth.instance.currentUser!=null) {
    emit(LoadingUpdateProduct());
    if(file!=null){
      final ref = FirebaseStorage.instance.ref().child('ProductImage').
      child(FirebaseAuth.instance.currentUser!.uid).
      child('${file!.path.split('/').last}.jpg');
      await ref.putFile(file!).then((p0) async {
        url = await ref.getDownloadURL();
      });
    }
  }
  FirebaseFirestore.instance.collection('Products').doc(id)
      .update({
    'UrlImage':url??imageUrl,
    'Name':name,
    'Location':location,
    'Status':status,
    'Desc':desc,
    'Hide':hide,
    'Quantity':quantity,
    'ExpTime':expTime,
    'CreateAt':Timestamp.now(),
  }).then((value) {
    emit(SuccessUpdateProduct());
  }).onError((error, stackTrace){
    emit(ErrorUpdateProduct(error.toString()));
  });
}

  List<ProductModel> searchProduct=[];
  void getSearchProduct(String search) {
    search = search.toLowerCase();
    searchProduct=[];
    searchProduct = productList.where((product) {
      var searchName = product.name.toLowerCase();
      var searchDesc = product.desc.toLowerCase();
      return searchName.contains(search) || searchDesc.toString().contains(search);
    }).toList();
    emit(GetSearchProduct());
  }

  void uploadOrder({
  required String urlImage,
  required String idProduct,
  required String uIdProduct,
  required String nameProduct,
  required String quantityProduct,
  required String allQuantityProduct,
  required String massageOrder,
  required String nameUser,
  required String idAdminCreatedProduct,
}){
    emit(LoadingAddOrder());
    if(FirebaseAuth.instance.currentUser!=null){
      String id=const Uuid().v4();
      OrderModel orderModel=OrderModel(
          urlImageProduct:urlImage,
        nameUser: nameUser,
        createAt: DateTime.now().toString(),
        massageOrder: massageOrder,
        idOrder: id,
        idProduct: idProduct,
        idUser: FirebaseAuth.instance.currentUser!.uid,
        nameProduct: nameProduct,
        quantityProduct: quantityProduct,
        idAdminCreatedProduct: idAdminCreatedProduct,
        confirmOne: true,
        confirmTwo: false,
        confirmThree: false,
      );
      int newQuantity=int.parse(allQuantityProduct)-int.parse(quantityProduct);
      FirebaseFirestore.instance.collection('Orders').doc(id)
          .set(orderModel.toMap()).then((value) {
            FirebaseFirestore.instance.collection('Products')
            .doc(uIdProduct).update({
              'Quantity':newQuantity.toString()
            }).then((value) {
              emit(SuccessAddOrder());
            });
      }).onError((error, stackTrace){
        emit(ErrorAddOrder(error.toString()));
      });
    }
  }
  
  List<OrderModel> ordersUserList=[];
  void getOrdersUser(){
    ordersUserList=[];
    emit(LoadingGetOrdersUser());
   if(FirebaseAuth.instance.currentUser!=null){
     FirebaseFirestore.instance.collection('Orders').where('IdUser',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
         .then((value){
       for (var element in value.docs) {
         ordersUserList.add(OrderModel.formJson(element.data()));
       }
       emit(SuccessGetOrdersUser());
     }).onError((error, stackTrace) {
       emit(ErrorGetOrdersUser(error.toString()));
     });
   }

  }

  List<OrderModel> ordersAdminList=[];
  void getOrdersAdmin(){
    ordersAdminList=[];
    emit(LoadingGetOrdersAdmin());
    if(FirebaseAuth.instance.currentUser!=null){
      FirebaseFirestore.instance.collection('Orders').where('IdAdminCreatedProduct',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
          .then((value){
        for (var element in value.docs) {
          ordersAdminList.add(OrderModel.formJson(element.data()));
        }
        emit(SuccessGetOrdersAdmin());
      }).onError((error, stackTrace) {
        emit(ErrorGetOrdersAdmin(error.toString()));
      });
    }
  }

  void confirmStepTwo({required String idProduct,required String idOrder}){
    try{
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR).then((value){
        if(value==idProduct){
          FirebaseFirestore.instance.collection('Orders')
              .doc(idOrder).update({
            'ConfirmTwo':true
          }).then((value) {
            emit(SuccessConfirmTwoState());
          });
        }
      });
    }catch(e){
      emit(ErrorConfirmTwoState());
    }
  }

  void confirmStepThree({required String idProduct,required String idOrder}){
    try{
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR).then((value){
        if(value==idProduct){
          FirebaseFirestore.instance.collection('Orders')
              .doc(idOrder).update({
            'ConfirmThree':true
          }).then((value) {
            emit(SuccessConfirmThreeState());
          });
        }
      });
    }catch(e){
      emit(ErrorConfirmThreeState());
    }
  }
}