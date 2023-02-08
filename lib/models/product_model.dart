import 'package:cloud_firestore/cloud_firestore.dart';
//splash
class ProductModel{
  final String name;
  final String desc;
  final String id;
  final String idProduct;
  final String location;
  final String status;
  final String hide;
  final String idAdminCreated;
  final String nameFolder;
  final String urlImage;
  final String quantity;
  final String expTime;
  final Timestamp createAt;

  factory ProductModel.formJson(Map<String, dynamic> json,){
    return ProductModel(
      name: json['Name'],
      nameFolder:json['NameFolder'],
      desc: json['Desc'],
      createAt: json['CreateAt'],
      id: json['Id'],
      expTime: json['ExpTime'],
      idAdminCreated: json['IdAdminCreated'],
      quantity: json['Quantity'],
      idProduct: json['IdProduct'],
      urlImage: json['UrlImage'],
      hide: json['Hide'],
       location: json['Location'],
      status: json['Status'],
    );
  }

  ProductModel(
      {required this.name,
      required this.desc,
      required this.id,
        required this.status,
        required this.location,
        required this.hide,
      required this.idProduct,
      required this.nameFolder,
      required this.urlImage,
      required this.quantity,
        required this.expTime,
        required this.idAdminCreated,
      required this.createAt});

  Map<String,dynamic> toMap(){
    return {
      'Name': name,
      'NameFolder':nameFolder,
      'Id': id,
      'CreateAt':createAt,
      'Desc':desc,
      'Quantity':quantity,
      'IdProduct':idProduct,
      'UrlImage':urlImage,
      'ExpTime':expTime,
      'Status':status,
      'Hide':hide,
      'Location':location,
      'IdAdminCreated':idAdminCreated,
    };

  }
}