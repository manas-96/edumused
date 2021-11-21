import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/StudentWeb.dart';
import 'package:intl/intl.dart';

import '../helper.dart';


class CourseDetails extends StatefulWidget {
  final id;
  final data;
  const CourseDetails({Key key, this.id, this.data}) : super(key: key);

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  addToCart()async{
    setState(() {
      cartLoader=true;
    });
    final body={
      "course_id": widget.id
    };
    final result = await APIClient().addCart(body);
    setState(() {
      cartLoader=false;
    });
    if(result=="failed"){
      if(mounted){
        setState(() {
          _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please try after some time"));
        });
      }
    }
    else{
      if(mounted){
        setState(() {
          _scaffoldKey.currentState.showSnackBar(APIClient.successToast("Course added to the cart"));
        });
      }
    }
  }
  addToWishList()async{
    setState(() {
      favLoader=true;
    });
    final body={
      "course_id": widget.id
    };
    final result = await APIClient().addWishList(body);
    setState(() {
      favLoader=false;
    });
    if(result=="failed"){
      if(mounted){
        setState(() {
          _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please try after some time"));
        });
      }
    }
    else{
      if(mounted){
        setState(() {
          _scaffoldKey.currentState.showSnackBar(APIClient.successToast("Course added to the Wishlist"));
        });
      }
    }
  }

  bool cartLoader=false;
  bool favLoader=false;

  @override
  void initState() {
    // TODO: implement initState
    if(widget.data==null){

    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    return Scaffold(key: _scaffoldKey,
      body: Container(
        height: h,
        width: w,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: h*0.4,
                width: w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.data["image"]),fit: BoxFit.cover
                  )
                ),
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap:(){
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: white,
                        child: Center(
                          child: Icon(Icons.arrow_back_ios,size: 20,),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: h*0.37,
              child: Container(
                height: h*0.6,
                width: w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey
                    )
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      Text(widget.data["title"]??"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      Text("By",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16)),
                      Text("Mr. ${widget.data.toString().contains("instructor")?widget.data["instructor"]["name"]??"":"Test Instructor"}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: color1)),
                      SizedBox(height: 15,),
                      Text("Duration",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      SizedBox(height: 4,),
                      Text("${widget.data["duration"]??""}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                      SizedBox(height: 8,),
                      Text("Course overview",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      SizedBox(height: 4,),
                      Text(Bidi.stripHtmlIfNeeded(widget.data["overview"].toString()).substring(1),
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 8,),
                      Text("Description",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      SizedBox(height: 4,),
                      Text(Bidi.stripHtmlIfNeeded(widget.data["courseoverview"].toString()).substring(1),
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 15,),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text("Reviews",style: TextStyle(fontSize: 18,color: color1),),
                      //       Row(
                      //         children: [
                      //           Text("4.7",style: TextStyle(fontSize: 16),),
                      //           RatingBarIndicator(
                      //             rating:5,
                      //             itemBuilder: (context, index) => Icon(
                      //               Icons.star,
                      //               color: Colors.green,
                      //             ),
                      //             itemCount: 1,
                      //             itemSize: 20.0,
                      //             direction: Axis.horizontal,
                      //           ),
                      //         ],
                      //       )
                      //
                      //     ],
                      //   ),
                      // ),
                      // reviews(),

                      SizedBox(height: 70,),
                      // RaisedButton(
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(18.0),
                      //     ),
                      //
                      //   onPressed: (){
                      //
                      //   },
                      //   color: color1,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Text("Enroll",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.white,
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        addToCart();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: color1,
                              width: 2
                            )
                          )
                        ),
                        width: MediaQuery.of(context).size.width/2,
                        height: 60,
                        alignment: Alignment.center,
                        child:cartLoader?CircularProgressIndicator(
                        ): Icon(Icons.add_shopping_cart,color: color1,size: 30,),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        addToWishList();
                      },
                      child: Container(
                        color: color1,
                        width: MediaQuery.of(context).size.width/2,
                        height: 60,
                        alignment: Alignment.center,
                        child: favLoader?CircularProgressIndicator(
                          backgroundColor: white,
                        ):Icon(Icons.favorite_border,color: white,size: 30,),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  // reviews(){
  //   return ListView.builder(
  //     itemCount: 3,
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemBuilder: (context,index){
  //       return Padding(
  //         padding: EdgeInsets.only(top: 8),
  //         child: Column(
  //           children: [
  //             ListTile(
  //               leading: Container(
  //                 height: 70,width: 70,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   image: DecorationImage(
  //                     image: AssetImage("images/profile_img.jpeg"),fit: BoxFit.fill
  //                   )
  //                 ),
  //               ),
  //               title: Text("Awesome series of Java. Thsi is a Syncing files to device Android SDK built for x86"
  //                   "Reloaded 6 of 765 libraries in 767ms.",
  //                 style: TextStyle(fontSize: 15),
  //                 textAlign: TextAlign.justify,
  //               ),
  //               subtitle: Padding(
  //                 padding: const EdgeInsets.only(top: 5.0),
  //                 child: RatingBarIndicator(
  //                   rating:5,
  //                   itemBuilder: (context, index) => Icon(
  //                     Icons.star,
  //                     color: Colors.amber,
  //                   ),
  //                   itemCount: 5,
  //                   itemSize: 20.0,
  //                   direction: Axis.horizontal,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
