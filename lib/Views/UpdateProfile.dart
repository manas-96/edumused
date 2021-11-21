import 'package:flutter/material.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';

import '../helper.dart';


class UpdateProfile extends StatefulWidget {
  final data;
  const UpdateProfile({Key key, this.data}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name="";
  String email="";
  String mobile="";
  String userId="";
  String image;
  bool checkData=false;
  @override
  void initState() {
    print(widget.data);
    // TODO: implement initState
    //fetchProfile();
    setState(() {
      name=widget.data["name"];
      email=widget.data["email"];
      image=widget.data["image"];
      mobile=widget.data["phone"];
      userId=widget.data["user_name"];
      print(email);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,

        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1
                        )
                      ]
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                      controller: TextEditingController()..text = name,
                      onChanged: (val){
                        name=val;
                      },
                      decoration:InputDecoration(
                          icon: Icon(Icons.person,color: color1,),
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ) ,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1
                      )
                    ]
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                      controller: TextEditingController()..text = email,
                      onChanged: (val){
                        email=val;
                      },
                      decoration:InputDecoration(
                          icon: Icon(Icons.email,color: color1,),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ) ,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1
                        )
                      ]
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                      controller: TextEditingController()..text = mobile,
                      onChanged: (val){
                        mobile=val;
                      },
                      decoration:InputDecoration(
                          icon: Icon(Icons.phone_android,color: color1,),
                          labelText: 'Mobile',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ) ,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1
                        )
                      ]
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                      controller: TextEditingController()..text = userId,
                      onChanged: (val){
                        userId=val;
                      },
                      decoration:InputDecoration(
                          icon: Icon(Icons.person,color: color1,),
                          labelText: 'User Name',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ) ,
                    ),
                  ),
                ),
                SizedBox(height: 35,),
                Padding(
                  padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.25,right: MediaQuery.of(context).size.width*0.25),
                  child: RaisedButton(
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      color: color1,
                      onPressed: (){
                        setState(() {
                          check=true;
                        });
                        updateProfile();
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child:check?Container(
                            height: 20,width: 20,
                            child: CircularProgressIndicator(backgroundColor: Colors.white,),
                          ):
                          Text("UPDATE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool check=false;
  updateProfile()async{
    final body={
      "name": name,
      "user_name": userId,
      "email": email,
      "phone": mobile,

    };
    final result = await APIClient().updateProfile(body);
    if(mounted){
      setState(() {
        check=false;
      });
    }
    if(result=="failed"){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Invalid credential"));
    }
    else{
      _scaffoldKey.currentState.showSnackBar(APIClient.successToast("Credential Updated successfully"));
    }
  }
}
