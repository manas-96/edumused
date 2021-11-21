import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/Component/noResult.dart';

import '../helper.dart';
import 'CourseDetails.dart';


class WishList extends StatefulWidget {
  final iconValue;
  const WishList({Key key, this.iconValue}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  bool empty=false;
  @override
  void initState() {
    // TODO: implement initState
    getCourses();
    getWishList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: widget.iconValue?? false,
        title: Text("WISHLIST",style: TextStyle(color: Colors.white),),
        backgroundColor: color1,

      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: body()
      ),
    );
  }
  fetchWishList(){
    if(isFailed){
      return noResult(context);
    }
    if(empty){
      return noResult(context);
    }
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.all(3),
          child: GestureDetector(
            onTap: (){
              var check=courses(data[index]["course"]);
              print(check);
              if(check){
                Get.to(CourseDetails(
                  id: data[index]["id"].toString(),
                  data: course,
                ));
              }
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
                              image: NetworkImage(data[index]["course"]["image"]),fit: BoxFit.contain

                          )
                      ),
                    ),
                    SizedBox(width: 6,),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 9),
                        Container(width: MediaQuery.of(context).size.width/1.7 ,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width/2.8,
                                child: Text(data[index]["course"]["title"],style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),overflow: TextOverflow.clip,),
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
                                                removeWishList(data[index]["id"].toString(),index);
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
                        SizedBox(height: 2),
                        Row(
                          children: <Widget>[
                            Text("Rs ${data[index]["course"]["orgprice"].toString()}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            SizedBox(width: 5,),
                            Text(data[index]["course"]["maxprice"].toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14,color: Colors.grey,
                                decoration: TextDecoration.lineThrough
                            ),)

                          ],
                        ),
                        SizedBox(height: 3,),
                        SizedBox(height: 5,),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var course;
  var courseData;
  getCourses()async{
    final result = await APIClient().courses("10", "0", "title");
    setState(() {
      courseData=result;
    });
  }
  courses(data){
    bool check=false;
    int i=courseData.length-1;
    print(i.toString());
    while(i>=0){
      print(courseData[i]["id"].toString()+data["id"].toString());
      if(courseData[i]["id"].toString()==data["id"].toString()){
        setState(() {
          course=courseData[i];
          check=true;
        });
      }
      i--;
    }
    return check;
  }
  bool isFailed=false;
  var data=[];
  bool loader=false;
  getWishList()async{
    setState(() {
      loader=true;
    });
    final result = await APIClient().wishlist();
    setState(() {
      loader=false;
    });
    print(result);
    if(result=="failed"){
      print("result");
      setState(() {
        isFailed=true;
      });
    }
    else{
      if(mounted){
        setState(() {
          data=result;
          if(data.isEmpty){
            empty=true;
          }
        });
      }
    }
  }
  removeWishList(productId,index)async{
    final result = await APIClient().removeWishList(productId);
    print(productId);
    (context as Element).reassemble();
    if(result!="failed"){
      _scaffoldKey.currentState.showSnackBar(APIClient.successToast("Product successfully removed"));
      setState(() {
        data.removeAt(index);
        if(data.isEmpty || data.length==0){
          empty=true;
        }
      });
      print(data.length);
    }
    else{
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please try after some time"));
    }
  }
  body(){
    if(loader){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if(isFailed){
      return Center(
        child: Text("Empty Cart",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
      );
    }
    return ListView(
      children: [
        fetchWishList(),
        Container(height: 50,)
      ],
    );
  }
}
