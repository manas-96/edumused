

import 'package:flutter/material.dart';

import '../../helper.dart';


noResult(context){
  return Column(
    children: [
      Container(
        height: 300,width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/search-icon.png"),fit: BoxFit.contain
            )
        ),
      ),
      Text("Sorry! No courses found :(",style: TextStyle(color: color1,fontSize: 16,fontWeight: FontWeight.w500),)
    ],
  );
}