import 'package:cloud_firestore/cloud_firestore.dart';

class FolderModel{
  final String idFolder;
  final String nameFolder;
  final String urlImage;
  final Timestamp createAt;


  factory FolderModel.formJson(Map<String, dynamic> json,){
    return FolderModel(
      createAt: json['CreateAt'],
      idFolder: json['IdFolder'],
      nameFolder: json['NameFolder'],
      urlImage: json['UrlImage'],
    );
  }

  FolderModel({required this.idFolder,
    required this.nameFolder,
    required this.urlImage,
    required this.createAt});


  Map<String,dynamic> toMap(){
    return {
      'IdFolder':idFolder,
      'NameFolder':nameFolder,
      'CreateAt':createAt,
      'UrlImage':urlImage,
    };

  }
}