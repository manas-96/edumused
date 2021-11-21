
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/Views/Search.dart';
import 'package:hemchaya_education/helper.dart';


appBar(context,title){
  return AppBar(
    elevation: 0,
    iconTheme: IconThemeData(
      color: white, //change your color here
    ),
    title: Text(title,style: TextStyle(color: white,),),
    backgroundColor: color1,
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: (){
          Get.to(Search());
        },
      )
    ],
  );
}