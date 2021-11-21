import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/CourseDetails.dart';
import 'package:hemchaya_education/Views/Instructor/AddCourse.dart';

import '../../helper.dart';



class InstructorBag extends StatefulWidget {
  const InstructorBag({Key key}) : super(key: key);

  @override
  _InstructorBagState createState() => _InstructorBagState();
}

class _InstructorBagState extends State<InstructorBag> {
  var data;
  courses()async{
    final result = await APIClient().courses("10", "0", "title");
    if(result!="failed"){
      if(mounted){
        setState(() {
          data=result;
        });
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    courses();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    return Scaffold(
        floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.add,color: white,),
            backgroundColor: color1,
            onPressed: (){
              Get.to(AddCourse());
            }
        ),
      body: Container(
        height: h,
        width: w,
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
                      Text("Take a look at your courses",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: white),),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: h*0.28,
              child: Container(
                height: h*0.7,
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
                      Text("Your Courses",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22)),
                      data==null?
                          Container(
                            height: 50,width: 50,
                            child: CircularProgressIndicator(),
                          )
                          :Container(
                        height: h*0.59 - 10,
                        child: ListView.builder(
                         itemCount: data.length,
                          itemBuilder: (context,index){
                           return subscriptionPlans(w, h, data[index]);
                          },
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
  subscriptionPlans(double w,double h,data ){
    return GestureDetector(
      onTap: (){
        //Get.to(CourseDetails());
      },
      child: Card(
        child: Container(
          // height: 150,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width/3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(data["image"]),fit: BoxFit.contain

                    )
                ),
              ),
              SizedBox(width: 6,),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 9),
                  Container(width: MediaQuery.of(context).size.width/1.9 ,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/2.8,
                          child: Text(data["title"],style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),overflow: TextOverflow.clip,),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete,color: Colors.red,),
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Remove from WishList?'),
                                    //content: Text('You are going to exit the application!!'),
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
                                          Navigator.pop(context);
                                          //SystemChannels.platform.invokeMethod('SystemNavigator.pop');

                                        },
                                      ),
                                    ],
                                  );
                                });

                          },
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text("RS ${data["orgprice"].toString()}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.green),),
                      SizedBox(width: 5,),
                      Text(data["maxprice"].toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 13,color: Colors.grey,
                          decoration: TextDecoration.lineThrough
                      ),)

                    ],
                  ),
                  // SizedBox(height: 3,),
                  // RatingBarIndicator(
                  //   rating:4,
                  //   itemBuilder: (context, index) => Icon(
                  //     Icons.star,
                  //     color: Colors.amber,
                  //   ),
                  //   itemCount: 5,
                  //   itemSize: 20.0,
                  //   direction: Axis.horizontal,
                  // ),
                  SizedBox(height: 5,),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
