import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/ChangePassword.dart';
import 'package:hemchaya_education/Views/Signin.dart';
import 'package:hemchaya_education/Views/UpdateProfile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../../helper.dart';


class InstructorProfile extends StatefulWidget {
  const InstructorProfile({Key key}) : super(key: key);

  @override
  _InstructorProfileState createState() => _InstructorProfileState();
}

class _InstructorProfileState extends State<InstructorProfile> {

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Log out from the application'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  logOut();
                },
              ),
            ],
          );
        });
  }
  logOut()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    pref.clear();
    Get.to(Signin());
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name="";
  String email="";
  String mobile="";
  String lastName="";
  String userId="";
  String image;
  bool checkData=false;
  fetchProfile()async{
    final result = await APIClient().profile();
    if(result=="failed"){
      if(mounted){
        setState(() {
          checkData=true;
        });
      }
    }
    else{
      if(mounted){
        setState(() {
          name=result["name"];
          email=result["email"];
          image=result["image"];
          mobile=result["phone"];
          userId=result["user_name"];
        });
      }
    }
    print(result);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProfile();

  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
//      appBar: AppBar(
//        elevation: 0,
//        title: Text("Profile"),
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.power_settings_new),
//            onPressed: (){
//            _onBackPressed();
//            },
//          )
//        ],
//      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,

        child: SingleChildScrollView(

          child: Column(
            children: <Widget>[
              Container(
                //height: MediaQuery.of(context).size.height/3,
                width: MediaQuery.of(context).size.width,
                color: color1,
                child: SafeArea(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.power_settings_new,color: Colors.white,),
                            onPressed: (){
                              _onBackPressed();
                            },
                          ),
                        ),
                      ),


                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0,-80),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                      ),]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0,right: 30,top: 10,bottom: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          height: 90,width: 90,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: image==null?AssetImage("images/profile_img.jpeg")
                                  :
                                  NetworkImage(image),fit: BoxFit.cover
                              )
                          ),
                        ),
                        SizedBox(height: 7,),
                        Text("$name"+" "+lastName,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Text(mobile,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300),),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
              ),
              content("Add Course",(){},),
              SizedBox(height: 10,),
              content("Update Profile",(){Get.to(UpdateProfile());}),
              SizedBox(height: 10,),
              content("Update Password",(){Get.to(ChangePassword());}),
              SizedBox(height: 10,),
              content("Log Out",(){})


            ],
          ),
        ),
      ),
    );
  }
  content(String name,onTap){
    return Padding(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Card(
        child: Container(
          child: ListTile(
            title: Text(name,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
            trailing: Icon(Icons.arrow_forward_ios,size: 25,),
            onTap: onTap
          ),

        ),
      ),
    );
  }
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        changePhoto(_image);
      } else {
        print('No image selected.');
      }
    });
  }
  changePhoto(image)async{
    var request = http.MultipartRequest("PUT", Uri.parse("https://hemchhaya.eazyclasses.com/api/profile"));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    request.headers.addAll({'Content-type': 'application/json','Authorization' : 'Bearer $token'});
    request.fields["name"]=name;
    request.fields["user_name"]=userId;
    request.fields["email"]=email;
    request.fields["phone"]=mobile;
    request.files.add(await http.MultipartFile.fromPath("image", "${image.path}"));
    var response =await request.send();
    var responsed= await http.Response.fromStream(response);
    print(response.statusCode);
    print(responsed.body);
    if(response.statusCode==200){
      print("Success=======================");
      _scaffoldKey.currentState.showSnackBar(APIClient.successToast("Photo successfully uploaded"));
    }
    else{
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Error while uploading image"));
    }
  }
}
