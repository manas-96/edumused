import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/Instructor/InstructorDashboard.dart';
import 'package:hemchaya_education/Views/Signin.dart';
import 'package:hemchaya_education/Views/TabScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>{
  checkLogin()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString("token")==null){
      Get.to(Signin());
    }
    else{
     // await APIClient().profile();
      if(preferences.getString("userType")=="1"){
        Get.to(TabScreen());
      }
      else{
        Get.to(InstructorDashboard());
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      checkLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color1,
                  color2
                ]
              )
          ),

        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height*0.22,

              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    height: 120,width: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/Graphic1.png")
                        )
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.52,

              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.32,width: MediaQuery.of(context).size.width*0.72,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/bg.png"),fit: BoxFit.fill
                        )
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}