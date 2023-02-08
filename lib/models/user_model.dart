import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String name;
  final String email;
  final String password;
  final String uId;
  final String typeAccount;
  final Timestamp createAt;

  UserModel( {required this.typeAccount,required this.name,required this.email,required this.password,required this.uId,required this.createAt,});

  factory UserModel.formJson(Map<String, dynamic> json,){
     return UserModel(
        name: json['Name'],
        email:json['Email'],
        password: json['Password'],
        createAt: json['CreateAt'],
        uId: json['Id'],
        typeAccount: json['TypeAccount'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'Name': name,
      'Email':email,
      'Id': uId,
      'CreateAt':createAt,
      'Password':password,
      'TypeAccount':typeAccount,
    };

  }
}