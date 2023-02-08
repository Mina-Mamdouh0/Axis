

import 'package:flutter/material.dart';

Widget show({required BuildContext context,
  required Function() camera,
  required Function() gallery,}){
  return AlertDialog(
    title:const  Text(
      'Choose Image',
      style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: camera,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Icon(Icons.photo,color: Colors.green,),
                SizedBox(width: 10,),
                Text('Camera',
                  style: TextStyle(
                      color: Colors.green,fontSize: 20
                  ),)
              ],
            ),
          ),
        ),
        InkWell(
          onTap: gallery,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Icon(Icons.camera,color: Colors.green,),
                SizedBox(width: 10,),
                Text('Gallery',
                  style: TextStyle(
                      color: Colors.green,fontSize: 20
                  ),)
              ],
            ),
          ),
        )
      ],
    ),
  );
}