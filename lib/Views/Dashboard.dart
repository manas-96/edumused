import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/CategoryProducts.dart';
import 'package:hemchaya_education/Views/Component/NavigationDrawer.dart';
import 'package:hemchaya_education/Views/Component/Products.dart';
import 'package:hemchaya_education/Views/Component/appBar.dart';
import 'package:hemchaya_education/Views/CourseDetails.dart';
import 'package:hemchaya_education/Views/SearchResult.dart';
import 'package:hemchaya_education/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool checkLms=false;
  var profileData;
  fetchProfile()async{
    final result = await APIClient().profile();
    if(result!="failed"){
      setState(() {
        profileData=result;
      });
      if(result["external_id"]!=null){
        setState(() {
          checkLms=true;
        });
      }
    }
    print(result);
  }

  String searchKey='';
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
  var cat;
  category()async{
    final result = await APIClient().productCategory();
    if(result!="failed"){
      if(mounted){
        setState(() {
          cat=result;
        });
      }
    }
  }

  var cartCount=0;
  getCartList()async{
    final result = await APIClient().cart();
    if(result!="failed" || result.isEmpty){
      setState(() {
        cartCount=result.length;
      });
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    getCartList();
    fetchProfile();
    category();
    courses();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Edumused"),
      drawer: NavigationDrawer(
        checkLms: checkLms,
        cartCount: cartCount,
      ),
      body: Container(
        color: white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi, ${profileData==null?"":profileData["name"]}",
                      style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: 20),),
                    SizedBox(height: 5,),
                    Text("Would you like to learn today?",
                      style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: 16),)

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cat==null?Container(height: 100,): Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Categories",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                  ),
                  displayCategory(),
                  SizedBox(height: 8,),
                  data==null?Container():Container(
                      height: 180.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,bottom: 0,right: 0,left: 0,
                            child: Carousel(
                              boxFit: BoxFit.cover,
                              autoplay: false,
                              animationCurve: Curves.fastOutSlowIn,
                              animationDuration: Duration(milliseconds: 1000),
                              dotSize: 6.0,
                              dotIncreasedColor: Colors.blueGrey,
                              dotBgColor: Colors.transparent,
                              //dotPosition: DotPosition.topRight,
                              dotVerticalPadding: 10.0,
                              showIndicator: true,
                              indicatorBgPadding: 7.0,
                              images: [
                                NetworkImage(APIClient().bannerImage[0]["image"]),
                                NetworkImage(APIClient().bannerImage[1]["image"]),

                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,bottom: 0,right: 0,left: 0,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Enhance your skills through",style: TextStyle(color: white,),),
                                  SizedBox(height: 4,),
                                  Text("Online courses & Certificate",style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: 17),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 10,),
                  productList(),
                  SizedBox(height: 10,),
                  productList2()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  productList2(){
    if(data==null){
      return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Container(
          height: 50,width: 50,
          child: CircularProgressIndicator(),
        ),
      );
    }
    return dashboardProducts(
      title: "Best for you",
      data: data,
      context: context
    );
  }
  productList(){
    if(data==null){
      return Container(

      );
    }
    return dashboardProducts(
      data: data,
      title: "Trending Courses",
      context: context
    );
  }
  displayCategory(){
    if(cat==null){
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cat.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: (){
                Get.to(CategoryProducts(
                  catId: cat[index]["id"].toString(),
                ));
              },
              child: Container(
                height: 90,width: 90,
                decoration: BoxDecoration(
                  color: color1,
                  shape: BoxShape.circle,
                  border: Border.all(color: white,width: 3),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey
                    )
                  ]
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(cat[index]["name"],style: TextStyle(color: white,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
