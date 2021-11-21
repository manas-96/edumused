import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/CourseDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';
import 'Component/appBar.dart';


class OrderDetails extends StatefulWidget {
  final details;
  final total;
  final data;
  const OrderDetails({Key key, this.details, this.total, this.data}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    orderDetails();
    fetchProfile();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Order Details"),
      body: details==null?Center(
        child: Container(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        ),
      ): ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hi, ${name??""}",
                    style: TextStyle(color: white,fontWeight: FontWeight.w300,fontSize: 16),),
                  SizedBox(height: 5,),
                  Text("Thank you for purchasing",
                    style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: 22),),
                  SizedBox(height: 5,),
                  Text("Here is the details",
                    style: TextStyle(color: white,fontWeight: FontWeight.w400,fontSize: 16),),

                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10,bottom: 8),
            child: Text("Courses",style: TextStyle(
              fontSize: 17,fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10,bottom: 8),
            child: ListView.builder(
              itemCount: widget.details.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.15,
                          color: Colors.grey
                        )
                      ]
                    ),
                    child: InkWell(
                      onTap: (){
                        Get.to(CourseDetails(
                          id: widget.details[index]["course"]["id"].toString(),
                          data: details["details"][index]["course"],
                        ));
                        // print(widget.details[index]["course"]["id"].toString());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage("https://www.edumused.com/"+widget.details[index]["course"]["image"].toString()),
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                            SizedBox(width: 25,),
                            Container(
                              width: MediaQuery.of(context).size.width-175,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.details[index]["course"]["title"],overflow: TextOverflow.clip,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                  ),
                                  SizedBox(height: 4,),
                                  Text(widget.details[index]["course"]["duration"].toString(),
                                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),
                                  ),
                                  Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage("images/rs.png"),size: 18,
                                      ),
                                      Text("${widget.details[index]["course"]["orgprice"].toString()}",
                                        style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10,bottom: 8),
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Price : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Text(widget.data["subtotal"].toString()+" "+widget.data["currency"],style: TextStyle(color: Colors.green),),

                    ],
                  ),
                  SizedBox(height: 4,),
                  Row(
                    children: [
                      Text("Transaction Id : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Text(widget.data["transaction_id"]),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Row(
                    children: [
                      Text("Date : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Text(widget.data["created_at"].toString().split("T").first),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  var details;
  orderDetails()async{
    final result = await APIClient().orderDetails(widget.data["id"].toString());
    if(result!="failed" || result.isNotEmpty){
      setState(() {
        details=result;
      });
    }
  }
  var profileData;
  String name;
  fetchProfile()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("name");
    });
    final result = await APIClient().profile();
    if(result!="failed"){
      setState(() {
        profileData=result;
      });
    }
  }
}
