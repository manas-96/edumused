import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/DataService/APIClient.dart';
import 'package:hemchaya_education/Views/Component/appBar.dart';
import 'package:hemchaya_education/Views/Component/noResult.dart';
import 'package:hemchaya_education/Views/OrderDetails.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Order List"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: displayOrders(),
      ),
    );
  }
  bool check=false;
  orders()async{
    final result = await APIClient().orderList();
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
    print(result[0]['subtotal']);
    return result;
  }
  displayOrders(){
    return FutureBuilder(
      future: orders(),
      builder: (context,snap){
        if(check){
          return noResult(context);
        }
        if(snap.data==null){
          return Center(
            child: Container(
              height: 50,width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return ListView.builder(
          itemCount: snap.data.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Get.to(OrderDetails(
                    details: snap.data[index]["details"],
                    total: snap.data[index]["subtotal"].toString(),
                    data: snap.data[index],
                  ));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [new BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1.0,
                    ),],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 90,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage("https://www.edumused.com/${snap.data[index]["details"][0]["course"]["image"]}")
                                ,fit: BoxFit.contain
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width-150,
                              child: Text("Transaction No : ${snap.data[index]["transaction_id"].toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                              overflow: TextOverflow.clip,),

                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Text("Order total : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                Text("${snap.data[index]["subtotal"].toString()} ${snap.data[index]["currency"]??""}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 14),),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text("${snap.data[index]["details"].length.toString()} Items",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),


                            SizedBox(height: 5,),
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
                          ],
                        ),
                      )
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
