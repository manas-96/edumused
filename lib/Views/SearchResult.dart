import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/dataService/APIClient.dart';
import 'package:hemchaya_education/Views/Component/appBar.dart';
import 'package:hemchaya_education/Views/CourseDetails.dart';

import '../helper.dart';


class SearchResult extends StatefulWidget {
  final searchKey;
  const SearchResult({Key key, this.searchKey}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, widget.searchKey.toString().toUpperCase()),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: displayResult(),
      ),
    );
  }
  bool check=false;
  courses()async{
    final result = await APIClient().search("10", "0", "title", widget.searchKey);
    if(result=="failed"){
      if(mounted){
        setState(() {
          check=true;
        });
      }
    }
    if(result.isEmpty){
      if(mounted){
        setState(() {
          check=true;
        });
      }
    }
    else return result;
  }
  displayResult(){
    return FutureBuilder(
      future: courses(),
      builder: (context,snap){
        if(check){
          return Column(
            children: [
              Container(
                height: 300,width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/search-icon.png"),fit: BoxFit.contain
                    )
                ),
              ),
              Text("Sorry! No result found :(",style: TextStyle(color: color1,fontSize: 16,fontWeight: FontWeight.w500),)
            ],
          );
        }
        if(snap.data==null){
          return Center(
            child: Container(
              height: 50,width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8
          ),
          itemCount: snap.data.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: (){
                  Get.to(CourseDetails(
                    data: snap.data[index],
                    id: snap.data[index]["id"].toString(),
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
                                image: NetworkImage(snap.data[index]["image"]),fit: BoxFit.contain
                            )
                        ),),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            color: Colors.grey.withOpacity(0.5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snap.data[index]["title"],style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text("RS ${snap.data[index]['orgprice'].toString()}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,fontSize: 14),),
                                  SizedBox(width: 5,),
                                  Text("RS ${snap.data[index]['maxprice'].toString()}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500,decoration: TextDecoration.lineThrough,fontSize: 13),),
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
      },
    );
  }
}
