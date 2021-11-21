import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/Dashboard.dart';
import 'package:hemchaya_education/Views/Instructor/InstructorDashboard.dart';
import 'package:hemchaya_education/Views/TabScreen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var firstNameController = TextEditingController();
  var userNameController = TextEditingController();
  var emailLoginController = TextEditingController();
  var passController = TextEditingController();

  bool faceLog=false;
  String firstName="";
  String userType="";
  String password="";
  String phone="";
  String email="";
  String userName="";

  String emailLogin="";
  String pass="";
  bool showPass=true;
  bool check=true;

  bool loginIndicator=false;
  bool registerIndicator=false;


  CameraController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(key: _scaffoldKey,
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
                    child: check?loginScreen():signupScreen()
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
                            setState(() {
                              check=true;
                              firstNameController.clear();
                              passController.clear();
                              userNameController.clear();
                              emailLoginController.clear();
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text("Sign in",style: TextStyle(color: white,fontSize: 18,fontWeight: FontWeight.bold),),
                            height: 80,
                            color: color1,
                            width: MediaQuery.of(context).size.width/2-1,
                          ),
                        ),
                        Container(
                          height: 60,
                          color: white,
                          width: 2,
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              check=false;
                              firstNameController.clear();
                              passController.clear();
                              userNameController.clear();
                              emailLoginController.clear();
                            });
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
      )
    );
  }

  login()async{
    final body={
    "email":emailLogin,
    "password":pass ,
    "device_name":"test",
    };
    final result = await APIClient().login(body);
    if(mounted){
      setState(() {
        loginIndicator=false;
      });
    }
    if(result!="failed"){
      final profile=await APIClient().profile();
      if(profile["user_type"].toString()=="1")
      Get.to(TabScreen());
      else Get.to(InstructorDashboard());
    }
    else{
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Invalid credential"));
    }
  }
  register()async{
    final body={
      "name":firstName,
      "user_type":"1",
      "email":email,
      "password":password,
      "user_name":userName,
      "phone": phone
    };
    final result=await APIClient().signup(body);
    if(mounted){
      setState(() {
        registerIndicator=false;
      });
    }
    if(result=="failed"){
      showAlertDialog(context,"Failed to sign up");
    }
    else{
      showAlertDialog(context,"Successfully registered"+"\n"+"Login to continue");
      if(mounted){
        setState(() {
          check=true;
        });
      }
    }
  }
  showAlertDialog(BuildContext context,String content) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.pop(context);
      setState(() {
        check=true;
      });},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  takePicture()async{
   try {

     final image = await controller.takePicture();
     faceMatch(image);
   } catch (e) {
     // If an error occurs, log the error to the console.
     print(e);
   }
 }

  faceMatch(image)async{
    print(image.path);
   var request = http.MultipartRequest("POST", Uri.parse("${APIClient().baseUrl}login"));
   request.headers.addAll({'Content-type': 'application/json'});
   request.fields["email"]=emailLogin;
   request.fields["device_name"]="Test";
   request.files.add(await http.MultipartFile.fromPath("login_profile_image", "${image.path}"));
   var response =await request.send();
   var responsed= await http.Response.fromStream(response);
   print(response.statusCode);
   if(response.statusCode==200){
     var data = json.decode(responsed.body);
     APIClient().storeAuth(data["access_token"]);
     APIClient().profile();
     print("Success=======================");
     if(emailLogin!="instructor")
       Get.to(TabScreen());
     else Get.to(InstructorDashboard());
   }
   else{
     _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Face does not matched"));
   }
   if(mounted){
     setState(() {
       faceLog=false;
       loginIndicator=false;
     });
   }
 }

  loginScreen(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        faceLog?Container(
          height: 250,
          width: 200,
          child: CameraPreview(controller),
        ):Container(
            height: 100,width: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("images/Graphic2.png")
                        ,fit: BoxFit.cover
                )
            ),
        ),
        SizedBox(height: 20,),
        faceLog?Container():Text("Sign in",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
        faceLog?Container():SizedBox(height: 5,),
        faceLog?Container():Padding(
          padding: const EdgeInsets.only(left: 50.0,right: 50),
          child: Text("Start by entering your details below & continue to Edumused",
            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),
            textAlign: TextAlign.center,),
        ),
        faceLog?Container(): SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 10),
          child: Container(height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: color1
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextFormField(
                controller: emailLoginController,
                onChanged: (val){
                  emailLogin=val;
                },
                decoration:InputDecoration(
                    icon: Icon(Icons.person,color: color1,),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                    border: InputBorder.none
                ) ,
              ),
            ),
          ),
        ),
        SizedBox(height: 3,),
        faceLog?Container(): Padding(
          padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 10),
          child: Container(height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: color1
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextFormField(obscureText: true,
                controller: passController,
                onChanged: (val){
                  pass=val;
                },
                decoration:InputDecoration(
                    icon: Icon(Icons.contacts_sharp,color: color1,),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),
                    border: InputBorder.none
                ) ,
              ),
            ),
          ),
        ),
        SizedBox(height: 3,),
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 10),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: color1
                )
            ),
            alignment: Alignment.center,
            child: RaisedButton(
              elevation: 0,
              color: color1,
              child: Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: loginIndicator? CircularProgressIndicator(backgroundColor: white,):
                Text("Sign in",style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: 18),),
              ),
              onPressed: (){
                if(faceLog){
                  if(emailLogin==""){
                    _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter Your email"));
                  }else{
                    setState(() {
                      loginIndicator=true;
                    });
                    takePicture();
                  }
                }
                else{
                  if(emailLogin==""){
                    _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter Your email"));
                  }
                  else if(pass==""){
                    _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter Your password"));
                  }
                  else{
                    setState(() {
                      loginIndicator=true;
                    });
                    login();
                  }
                }
              },
            ),
          ),
        ),
        SizedBox(height: 3,),
        Text("OR"),
        SizedBox(height: 3,),
        InkWell(
          onTap: (){
            setState(() {
              faceLog=!faceLog;
            });
            if(faceLog){
              controller = CameraController(cameras[1], ResolutionPreset.max);
              controller.initialize().then((_) {
                if (!mounted) {
                  return;
                }
                setState(() {});
              });
              print(controller.cameraId.toString());
            }
            else{
              controller.dispose();
            }
          },
          child: Text(!faceLog?"Face Login":"Password login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
        )
      ],
    );
  }
  signupScreen(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 70,width: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: color1,
                    blurRadius: 1.5
                )
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: _image==null?AssetImage("images/user_icon.png")
                  :FileImage(_image),fit: BoxFit.cover
              )
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 4,right: 4,
                child: InkWell(
                  child: Icon(Icons.camera_alt,color: Colors.white,),
                  onTap: (){
                    getImage();
                  },
                )
              )
            ],
          )
        ),
        SizedBox(height: 10,),
        Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 50.0,right: 50),
          child: Text("Start by entering your details below & sign up for free",
            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),
          textAlign: TextAlign.center,),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 10),
          child: Container(height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color1
              )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextFormField(
                controller: firstNameController,
                onChanged: (val){
                  firstName=val;
                },
                decoration:InputDecoration(
                    icon: Icon(Icons.person,color: color1,),
                    hintText: 'Name',
                    hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                    border: InputBorder.none
                ) ,
              ),
            ),
          ),
        ),
        SizedBox(height: 3,),
        Padding(
          padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 10),
          child: Container(height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: color1
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextFormField(
                controller: userNameController,
                onChanged: (val){
                  userName=val;
                },
                decoration:InputDecoration(
                    icon: Icon(Icons.contacts_sharp,color: color1,),
                    hintText: 'User name',
                    hintStyle: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),
                    border: InputBorder.none
                ) ,
              ),
            ),
          ),
        ),
        SizedBox(height: 3,),
        Padding(
          padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 10),
          child: Container(height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: color1
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextFormField(
                onChanged: (val){
                  email=val;
                },
                decoration:InputDecoration(
                    icon: Icon(Icons.email,color: color1,),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),
                    border: InputBorder.none
                ) ,
              ),
            ),
          ),
        ),
        SizedBox(height: 3,),
        Padding(
          padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 10),
          child: Container(height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: color1
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                onChanged: (val){
                  phone=val;
                },
                decoration:InputDecoration(
                    icon: Icon(Icons.phone_android,color: color1,),
                    hintText: 'Mobile',
                    hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                    border: InputBorder.none
                ) ,
              ),
            ),
          ),
        ),
        SizedBox(height: 3,),
        Padding(
          padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 10),
          child: Container(height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: color1
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextFormField(
                obscureText: true,
                onChanged: (val){
                  password=val;
                },
                decoration:InputDecoration(
                    icon: Icon(Icons.lock,color: color1,),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                    border: InputBorder.none
                ) ,
              ),
            ),
          ),
        ),
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 10),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: color1
                )
            ),
            alignment: Alignment.center,
            child: RaisedButton(
              elevation: 0,
              color: color1,
              child: Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: registerIndicator? CircularProgressIndicator(backgroundColor: white,):
                 Text("Sign up",style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: 18),),
              ),
              onPressed: (){
                if(email==""){
                  _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter Your email"));
                }
                else if(_image==null){
                  _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please upload profile image"));
                }
                else if(userName==""){
                  _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter Your username"));
                }
                else if(firstName==""){
                  _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter Your name"));
                }
                else if(phone==""){
                  _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter Your mobile number"));
                }
                else if(password==""){
                  _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter Your password"));
                }
                else{
                  setState(() {
                    registerIndicator=true;
                  });
                  compressPhoto(_image);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  var resultImage;
  compressPhoto(image)async{
    final bytes = image.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );
    print(kb);
    print(croppedFile.readAsBytesSync().lengthInBytes/1024);

    if(croppedFile.readAsBytesSync().lengthInBytes/1024>1024){
      var result = await FlutterImageCompress.compressAndGetFile(
          croppedFile.path, croppedFile.path,quality: 70
      );
      print(result.readAsBytesSync().lengthInBytes/1024);
      if(mounted){
        setState(() {
          resultImage=result;
        });
      }
    }
    else{
      if(mounted){
        setState(() {
          resultImage=croppedFile;
        });
      }
    }
    registerWithPhoto(resultImage);
  }
  registerWithPhoto(image)async{
    var request = http.MultipartRequest("POST", Uri.parse("${APIClient().baseUrl}signup"));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    request.headers.addAll({'Content-type': 'application/json','Authorization' : 'Bearer $token'});
    request.fields["name"]=firstName;
    request.fields["user_name"]=userName;
    request.fields["user_type"]="1";
    request.fields["email"]=email;
    request.fields["phone"]=phone;
    request.fields["password"]=password;
    request.files.add(await http.MultipartFile.fromPath("image", "${image.path}"));
    var response =await request.send();
    var responsed= await http.Response.fromStream(response);
    print(response.statusCode);
    print(responsed.body);
    setState(() {
      registerIndicator=false;
    });
    if(response.statusCode==200){
      showAlertDialog(context, "Successfully registered\nLogin to continue.");
    }
    else{
      var result= json.decode(responsed.body);
      if(result["errors"].toString().contains("user_name")){
        setState(() {
          result=result["errors"]["user_name"][0];
        });
      }
      else if(result["errors"].toString().contains("email")){
        setState(() {
          result=result["errors"]["email"][0];
        });
      }
      else if(result["errors"].toString().contains("phone")){
        setState(() {
          result=result["errors"]["phone"][0];
        });
      }
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast(result));
    }
  }
}