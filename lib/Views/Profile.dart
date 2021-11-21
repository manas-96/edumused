import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/ChangePassword.dart';
import 'package:hemchaya_education/Views/Signin.dart';
import 'package:hemchaya_education/Views/UpdateProfile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';

class Profile extends StatefulWidget {
  final iconValue;

  const Profile({Key key, this.iconValue}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
  String lmsToken="";
  String image;
  bool checkData=false;
  var resultImage;
  var data;
  bool checkLms=false;
  fetchProfile()async{
    final profile = await APIClient().profile();
    if(profile!="failed"){
      if(profile["external_id"]!=null){
        setState(() {
          checkLms=true;
        });
      }
    }
    SharedPreferences result = await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        name=result.getString("name");
        email=result.getString("email");
        image=result.getString("image");
        mobile=result.getString("phone");
        userId=result.getString("username");
        lmsToken=result.getString("lmsToken");
        data={
          "name": name,
          "user_name": userId,
          "email": email,
          "phone": mobile,
          "image": image,
        };
        print(email);
      });
    }
  }


  @override
  void initState() {
    fetchProfile();
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(key: _scaffoldKey,
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              widget.iconValue==true?IconButton(
                                icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ):Container(),
                              IconButton(
                                icon: Icon(Icons.power_settings_new,color: Colors.white,),
                                onPressed: (){
                                  _onBackPressed();
                                },
                              ),
                            ],
                          )
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
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: color1,
                                blurRadius: 1.5
                              )
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: image==null? resultImage==null?AssetImage("images/user_icon.png")
                              :FileImage(resultImage)
                                :
                                NetworkImage(image),fit: BoxFit.cover
                            )
                          ),
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt,color: Colors.white,),
                            onPressed: (){
                              getImage();
                            },
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
              content("Update Profile",(){Get.to(UpdateProfile(data: data,));}),
              SizedBox(height: 10,),
              content("Update Password",(){Get.to(ChangePassword());}),
              SizedBox(height: 10,),
              checkLms?content("My courses",(){Get.to(ChangePassword());}):Container(),
              checkLms?SizedBox(height: 10,):Container(),
              content("Log Out",(){_onBackPressed();})

              
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
            onTap: onTap,
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
        compressPhoto(_image);
      } else {
        print('No image selected.');
      }
    });
  }
  changePhoto(image)async{
    var request = http.MultipartRequest("POST", Uri.parse("${APIClient().baseUrl}profile"));
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
      fetchProfile();
    }
    else{
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Error while uploading image"));
    }
  }
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
    changePhoto(resultImage);
  }
}