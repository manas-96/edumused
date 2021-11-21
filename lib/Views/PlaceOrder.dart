import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/Component/appBar.dart';
import 'package:hemchaya_education/Views/Payment.dart';

import '../helper.dart';


class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loader=false;
  String name;
  String email;
  String phone;
  String address1='';
  String address2='';
  String country='';
  String state='';
  String city='';
  String zip='';
  var nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      appBar: appBar(context, "CheckOut Details"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 10),
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
                        controller: TextEditingController()..text = name,
                        onChanged: (val){
                          name=val;
                        },
                        decoration:InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            border: InputBorder.none
                        ) ,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 10),
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
                        controller: TextEditingController()..text = email,
                        onChanged: (val){
                          email=val;
                        },
                        decoration:InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            border: InputBorder.none
                        ) ,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 10),
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
                        keyboardType: TextInputType.number,
                        controller: TextEditingController()..text = phone,
                        onChanged: (val){
                          phone=val;
                        },
                        decoration:InputDecoration(
                            hintText: 'Phone',
                            hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            border: InputBorder.none
                        ) ,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 10),
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
                          address1=val;
                        },
                        decoration:InputDecoration(
                            hintText: 'Address1',
                            hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            border: InputBorder.none
                        ) ,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 10),
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
                          address2=val;
                        },
                        decoration:InputDecoration(
                            hintText: 'Address2',
                            hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            border: InputBorder.none
                        ) ,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 10),
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
                          city=val;
                        },
                        decoration:InputDecoration(
                            hintText: 'City',
                            hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            border: InputBorder.none
                        ) ,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 10),
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
                          state=val;
                        },
                        decoration:InputDecoration(
                            hintText: 'State',
                            hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            border: InputBorder.none
                        ) ,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 10),
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
                        keyboardType: TextInputType.number,
                        onChanged: (val){
                          zip=val;
                        },
                        decoration:InputDecoration(
                            hintText: 'Zip',
                            hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            border: InputBorder.none
                        ) ,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 10),
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
                          country=val;
                        },
                        decoration:InputDecoration(
                            hintText: 'Country',
                            hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            border: InputBorder.none
                        ) ,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,top: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: color1,
                    ),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: color1,
                      onPressed: ()=>orderValidation(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child : loader ? CircularProgressIndicator(
                          backgroundColor: white,
                        ) : Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Next",
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  orderValidation(){
    if(name==null){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter name"));
    }
    else if(email==null){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter email"));
    }
    else if(phone==null){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter phone"));
    }
    else if(address1==""){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter address1"));
    }
    else if(address2==""){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter address2"));
    }
    else if(city==""){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter city"));
    }
    else if(state==""){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter state"));
    }
    else if(country==""){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter country"));
    }
    else if(zip==""){
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please enter zip"));
    }
    else{
      placeOrder();
    }
  }
  placeOrder()async{
    setState(() {
      loader=true;
    });
    final body={
      "name": name,
      "email": email,
      "phone": phone,
      "address1": address1,
      "address2": address2,
      "country": country,
      "state": state,
      "city": city,
      "zip": zip
    };
    final result = await APIClient().placeOrder(body);
    setState(() {
      loader=false;
    });
    print(result);
    Get.to(Payment(url: result["url"],));
  }
}
