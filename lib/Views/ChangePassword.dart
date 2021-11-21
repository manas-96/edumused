

import 'package:flutter/material.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';

import '../helper.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String password="";
  String confirm="";
  String old="";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Update Password"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(height: 35,),
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
                      obscureText: true,
                      onChanged: (val){
                        old=val;
                      },
                      decoration:InputDecoration(
                          labelText: 'Old Password',
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
                      obscureText: true,
                      onChanged: (val){
                        password=val;
                      },
                      decoration:InputDecoration(
                          labelText: 'New Password',
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
                      obscureText: true,
                      onChanged: (val){
                        confirm=val;
                      },
                      decoration:InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ) ,
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                Padding(
                  padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.25,right: MediaQuery.of(context).size.width*0.25),
                  child: RaisedButton(
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      color: color1,
                      onPressed: (){
                        if(old==""){
                          _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter old password"));
                        }
                        else if(password==""){
                          _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter new password"));
                        }
                        else if(password!=confirm){
                          _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Password & Confirm password are not matched"));
                        }
                        else{
                          setState(() {
                            check=true;
                          });
                          updateProfile();
                        }
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child:check?Container(
                            height: 20,width: 20,
                            child: CircularProgressIndicator(backgroundColor: Colors.white,),
                          ):
                          Text("SUBMIT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
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
      "old_password": "123456",
      "password": "123456",
      "password_confirmation": "123456"
    };
    final result = await APIClient().changePassword(body);
    print(result);
    if(mounted){
      setState(() {
        check=false;
      });
    }
    if(result=="failed"){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Invalid Password"));
    }
    else{
      _scaffoldKey.currentState.showSnackBar(APIClient.successToast("Password Updated successfully"));
    }
  }
}
