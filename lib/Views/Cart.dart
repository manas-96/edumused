import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/Component/noResult.dart';
import 'package:hemchaya_education/Views/PlaceOrder.dart';
import 'package:hemchaya_education/helper.dart';

import 'CourseDetails.dart';


class Cart extends StatefulWidget {
  final iconValue;
  const Cart({Key key, this.iconValue}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

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
  bool loader=false;
  double maxPrice=0,discountedPrice=0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFailed=false;
  var data=[];
  getCartList()async{
    setState(() {
      loader=true;
    });
    final result = await APIClient().cart();
    setState(() {
      loader=false;
    });
    if(result=="failed" || result.isEmpty){
      setState(() {
        isFailed=true;
      });
    }
    else{
      priceCalculate(result);
    }
  }
  priceCalculate(result){
    if(mounted){
      setState(() {
        maxPrice=0;
        discountedPrice=0;
        data=result;
        for(int i=0;i<data.length;i++){
          maxPrice=maxPrice+double.parse(data[i]["course"]["maxprice"].toString());
          discountedPrice=discountedPrice+double.parse(data[i]["course"]["orgprice"].toString());
        }
        print(discountedPrice.toString());
      });
    }
  }
  removeCart(productId,index)async{
    final result = await APIClient().removeCart(productId);
    (context as Element).reassemble();
    if(result!="failed"){
      _scaffoldKey.currentState.showSnackBar(APIClient.successToast("Product successfully removed"));
      setState(() {
        data.removeAt(index);
        priceCalculate(data);
        if(data.isEmpty || data.length==0){
          isFailed=true;
        }
      });
      print(data.length);
    }
    else{
      _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please try after some time"));
    }
  }

  @override
  void initState() {
    getCourses();
    getCartList();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: widget.iconValue??false,
        title: Text("CART",style: TextStyle(color: Colors.white),),
        backgroundColor: color1,
        elevation: 0,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: body()
      ),
    );
  }
  body(){
    if(loader){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if(isFailed){
      return noResult(context);
    }
    return ListView(
      children: [
        fetchCartList(),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1.0,
                  ),]
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  leading: Icon(Icons.local_offer),
                  title: Text("Apply Coupan"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){

                  },
                ),
              )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: white,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  priceDetails("Total MRP", "$maxPrice",TextStyle(fontWeight: FontWeight.w400,fontSize: 17)),
                  SizedBox(height: 5,),
                  priceDetails("Discount", "${maxPrice-discountedPrice}",TextStyle(fontWeight: FontWeight.w400,fontSize: 17)),
                  SizedBox(height: 5,),
                  priceDetails("Discounted MRP", "$discountedPrice",TextStyle(fontWeight: FontWeight.w400,fontSize: 17)),
                  Divider(thickness: 1.5,),
                  priceDetails("Total Amount", "$discountedPrice",TextStyle(fontWeight: FontWeight.w500,fontSize: 17,)),

                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            color: color1,
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            onPressed: (){
              if(isFailed){
                _scaffoldKey.currentState.showSnackBar(APIClient.errorToast("Please add a Course first"));
              }else{
                Get.to(PlaceOrder(

                ));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child:loader?CircularProgressIndicator(
                backgroundColor: Colors.white,
              ):
              Text("Check Out",style: TextStyle(color: white,fontSize: 18,fontWeight: FontWeight.bold),),
            ),
          ),
        ),
        SizedBox(height: 80,),
      ],
    );
  }
  priceDetails(String name, String price, TextStyle style){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 17),),
          Row(
            children: [
              ImageIcon(
                AssetImage("images/rs.png")
              ),
              Text(price,style: style,)
            ],
          )
        ],
      ),
    );
  }
  fetchCartList(){
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
                                          title: Text('Remove from cart?'),
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
                                                removeCart(data[index]["id"].toString(),index);
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
                            ImageIcon(AssetImage("images/rs.png")),
                            Text("${data[index]["course"]["orgprice"].toString()}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            SizedBox(width: 5,),
                            Text(data[index]["course"]["maxprice"].toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14,color: Colors.grey,
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

}
