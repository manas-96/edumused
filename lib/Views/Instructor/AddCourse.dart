import 'package:flutter/material.dart';

import '../../helper.dart';



class AddCourse extends StatefulWidget {
  const AddCourse({Key key}) : super(key: key);

  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.3,
                color: color1,
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:white,
                                    shape: BoxShape.circle
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.arrow_back_ios_outlined,color: color1,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4,),

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
                      Text("Upload a new courses",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: white),),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.28,
              child: Container(
                height: MediaQuery.of(context).size.height*0.7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      Text("Add Course",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
                      SizedBox(height: 10,),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              color: Colors.grey,
                            )
                          ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: "Title",
                                border: InputBorder.none
                            ),
                          ),
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
}
