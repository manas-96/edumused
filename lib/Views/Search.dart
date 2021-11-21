import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/Views/Component/appBar.dart';
import 'package:hemchaya_education/Views/SearchResult.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';


class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchKey="";
  @override
  void initState() {
    // TODO: implement initState
    getSearchKey();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      appBar: appBar(context, "Search"),
      body: Container(
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
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 0.4,
                      )
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                          child: TextField(
                            onSubmitted: (value) {
                              if(searchKey!=""){
                                saveSearchKey(searchKey);
                                Get.to(SearchResult(
                                  searchKey: searchKey,
                                ));
                              }
                            },
                            autofocus:true,
                            textInputAction: TextInputAction.search,
                            onChanged: (val){
                              setState(() {
                                searchKey=val;
                                sortKeys();
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search",

                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search,color: color1,),
                        onPressed: (){
                          if(searchKey!=""){
                            saveSearchKey(searchKey);
                            Get.to(SearchResult(
                              searchKey: searchKey,
                            ));
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            ListTile(
              title: Text("Previous search history"
                ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
              ),

            ),
            savedKeys.isNotEmpty?
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: savedKeys.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Text(savedKeys[index]),
                      onTap: (){
                        setState(() {
                          searchKey=savedKeys[index];
                          Get.to(SearchResult(searchKey: searchKey,));
                        });
                      },
                    );
                  },
                )
                :
                Container()
          ],
        ),
      ),
    );
  }
  List savedKeys=[];
  sortKeys(){
    List temp=[];
    for(int i=0;i<savedKeys.length;i++){
      if(savedKeys[i].toString().contains(searchKey))
        temp.add(savedKeys[i]);
    }
    setState(() {

    });
  }
  getSearchKey()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString("searchKey")!=null){
      if(mounted){
        setState(() {
          savedKeys= json.decode(preferences.getString("searchKey"));
          print(savedKeys);
        });
      }
    }
  }
  saveSearchKey(val)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        savedKeys.add(val);
      });
    }
    preferences.setString("searchKey", json.encode(savedKeys));
  }
}
