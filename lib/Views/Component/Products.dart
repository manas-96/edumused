import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper.dart';
import '../CourseDetails.dart';


 dashboardProducts({data,title,context}){
   return Container(
       width: MediaQuery.of(context).size.width,
       alignment: Alignment.center,
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(" $title",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
         SizedBox(height: 5,),
         Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
           scrollDirection: Axis.horizontal,
           itemCount: data.length,
           itemBuilder: (context,index){
            return Padding(
             padding: const EdgeInsets.all(8.0),
             child: InkWell(
              onTap: (){
               Get.to(CourseDetails(
                data: data[index],
                id: data[index]["id"].toString(),
               ));
              },
              child: Container(
               height: 200,
               width: 150,
               decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(15),
                   boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey
                    )
                   ]
               ),
               child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Container(
                  width: 150,height: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)
                      ),
                      color: Colors.white,
                      image: DecorationImage(
                          image: NetworkImage(data[index]["image"]),fit: BoxFit.contain
                      )
                  ),),
                 Container(
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                       bottomRight: Radius.circular(15),
                       bottomLeft: Radius.circular(15),
                      ),
                      color: white
                  ),
                  child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Text(data[index]["title"],style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                     SizedBox(height: 5,),
                     Row(
                      children: [
                       ImageIcon(
                        AssetImage("images/rs.png"),size: 17,
                       ),
                       Text("${data[index]['orgprice'].toString()}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,fontSize: 14),),
                       SizedBox(width: 5,),
                       Text(" ${data[index]['maxprice'].toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500,decoration: TextDecoration.lineThrough,fontSize: 13),),
                      ],
                     ),
                    ],
                   ),
                  ),
                 ),
                ],
               ),
              ),
             ),
            );
           },
          ),
         )
        ],
       )
   );
 }

/// cart & wishlist products

 cartProducts(data){

 }