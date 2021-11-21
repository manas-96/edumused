import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/Component/noResult.dart';
import 'package:hemchaya_education/Views/CourseDetails.dart';


import '../helper.dart';
import 'Component/appBar.dart';


class CategoryProducts extends StatefulWidget {
  final catId;
  const CategoryProducts({Key key, this.catId}) : super(key: key);

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  @override
  void initState() {
    // TODO: implement initState
    getData();
    getSubCategory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Categories"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: white,
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Filters",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    IconButton(
                      icon: Icon(Icons.filter_vintage),
                      onPressed: (){
                        subCategories();
                      },
                    )
                  ],
                ),
              ),
            ),
            products()
          ],
        ),
      ),
    );
  }
  var data;
  bool emptyData=false;
  getData()async{
    print(widget.catId.toString());
    final result = await APIClient().productByCategory("10", "0", "title", widget.catId.toString());
    if(result=="failed" || result.isEmpty){
      if(mounted){
        setState(() {
          emptyData=true;
        });
      }
    }
    else{
      if(mounted){
        setState(() {
          data=result;
        });
      }
    }
  }

  products(){
    if(emptyData){
      return noResult(context);
    }
    if(data==null){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,width: 50,
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 8
      ),
      itemCount: data.length,
      itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: (){
              Get.to(CourseDetails(
                data: data[index],
                id: data[index]["id"].toString(),
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey
                    )
                  ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)
                        ),
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(data[index]["image"]),fit: BoxFit.contain
                        )
                    ),),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        color: Colors.grey.withOpacity(0.1)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data[index]["title"],style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage("images/rs.png"),size: 17,
                              ),
                              Text("${data[index]['orgprice'].toString()}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,fontSize: 14),),
                              SizedBox(width: 5,),
                              Text(" ${data[index]['maxprice'].toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500,decoration: TextDecoration.lineThrough,fontSize: 13),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  int groupValue;

  setupAlertDialoadContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Colors.white,
      ),
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: subCategory.length,
        itemBuilder: (context,index) {
          return RadioListTile(
            value: subCategory[index]["id"],
            groupValue: groupValue,
            activeColor: color1,
            title: Text(subCategory[index]["name"]),
            onChanged: (val){
              print(val);
              setState(() {
                groupValue=val;
                selectedSub=groupValue.toString();
              });
              Navigator.pop(context);
              subCategoryProduct();
            },
          );
        },
      ),
    );
  }
  subCategories() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Options'),
            content: checkSub? Text("Empty Data") :setupAlertDialoadContainer(),
          );
        });
  }
  String selectedSub;
  List subCategory;
  bool checkSub=false;
  getSubCategory()async{
    final result = await APIClient().productSubCategory(widget.catId);
    if(result=="failed" || result.isEmpty){
      if(mounted){
        setState(() {
          checkSub=true;
        });
      }
    }
    else{
      if(mounted){
        setState(() {
          subCategory=result;
        });
      }
    }
  }
  subCategoryProduct()async{
    final result = await APIClient().productBySubCategory("10", "0", "title", widget.catId.toString(), selectedSub);
    if(result=="failed" || result.isEmpty){
      if(mounted){
        setState(() {
          emptyData=true;
        });
      }
    }
    else{
      if(mounted){
        setState(() {
          data=result;
        });
      }
    }
  }
}
