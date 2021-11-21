import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hemchaya_education/helper.dart';


class InstructorHome extends StatefulWidget {
  const InstructorHome({Key key}) : super(key: key);

  @override
  _InstructorHomeState createState() => _InstructorHomeState();
}

class _InstructorHomeState extends State<InstructorHome> {
  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: w,
                height: h*0.3,
                color: color1,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: w,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hello ,",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: white),),
                                SizedBox(height: 4,),
                                Text("Manas Saha !",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: white),),
                              ],
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: white,
                                image: DecorationImage(
                                  image: AssetImage("images/hem-logo.png"),fit: BoxFit.fill
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text("Welcome to Edumused",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: white),),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: h*0.28,
              child: Container(
                height: h*0.67,
                width: w,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text("Subscription Plans",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22)),
                      Container(
                        height: h*0.59 - 10,
                        child: ListView(
                          children: [
                            subscriptionPlans(w,h,"Silver Plan,","1199"),
                            subscriptionPlans(w,h,"Gold Plan,","1999"),
                            subscriptionPlans(w,h,"Platinum Plan,","2999"),
                            SizedBox(height: 30,)
                          ],
                        ),
                      )
                    ],

                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  subscriptionPlans(double w,double h,String name, String price, ){
    return Padding(
      padding: const EdgeInsets.only(top: 10, ),
      child: Container(
        width: w,
        height: h*0.30,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/book2.jpg"),fit: BoxFit.cover
          ),
          color: white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
            )
          ]
        ),
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(name,style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 4,),
              Text("Price RS $price",style: TextStyle(color: white,fontWeight: FontWeight.w500,fontSize: 18),),
            ],
          ),
        ),
      ),
    );
  }
}
