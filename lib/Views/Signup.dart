import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/Views/Signin.dart';
import 'package:hemchaya_education/helper.dart';


class Signup extends StatefulWidget {
  const Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: color1,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height-85,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60)
                    )
                  ),
                  child: Column(

                  ),
                ),
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  color: color1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Get.to(Signin());
                        },
                        child: Container(
                          height: 80,
                          color: color1,
                          width: MediaQuery.of(context).size.width/2-1,
                          alignment: Alignment.center,
                          child: Text("Sign in",style: TextStyle(color: white,fontSize: 18,fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Container(
                        height: 60,
                        color: white,
                        width: 2,
                      ),
                      InkWell(
                        onTap: (){

                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("Sign up",style: TextStyle(color: white,fontSize: 18,fontWeight: FontWeight.bold),),
                          height: 80,
                          color: color1,
                          width: MediaQuery.of(context).size.width/2-1,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
