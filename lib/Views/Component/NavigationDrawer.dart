import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/Views/Cart.dart';
import 'package:hemchaya_education/Views/Dashboard.dart';
import 'package:hemchaya_education/Views/OrderList.dart';
import 'package:hemchaya_education/Views/Profile.dart';
import 'package:hemchaya_education/Views/StudentWeb.dart';
import 'package:hemchaya_education/Views/WishList.dart';

import '../../helper.dart';

class NavigationDrawer extends StatelessWidget {
  final checkLms;
  final cartCount;

  const NavigationDrawer({Key key, this.checkLms, this.cartCount}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          createDrawerBodyItem(
              icon: Icons.home,text: 'Home',onTap: (){Get.to(Dashboard());}),
          createDrawerBodyItem(
              icon: Icons.account_circle,text: 'Profile',onTap: (){Get.to(Profile(iconValue: true,));}),

          createDrawerBodyItem(
              icon: Icons.add_shopping_cart,text: 'Cart',onTap: (){Get.to(Cart(
            iconValue: true,
          ));}, count: cartCount),
          createDrawerBodyItem(
              icon: Icons.favorite,text: 'WishList',onTap: (){Get.to(WishList(iconValue: true,));}),
          checkLms?createDrawerBodyItem(
              icon: Icons.book,text: 'Goto LMS',onTap: (){
                Get.to(StudentWeb());
          }):Container(),
          createDrawerBodyItem(
              icon: Icons.shopping_bag,text: 'Order List',onTap: (){Get.to(OrderList());}),
          SizedBox(height: 50,),
          ListTile(
            //leading: Icon(Icons.copyright,color: Colors.red,),
            title: Text('Hemchaya Pvt. Ltd.',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            onTap: () {},
          ),
        ],
      ),
    );
  }
  Widget createDrawerBodyItem(
      {IconData icon, String text, GestureTapCallback onTap, int count}) {
    return ListTile(
      title: Text(text,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
      subtitle: count==null?Container(): Text("$count items"),
      leading: Icon(icon,color: color1,),
      onTap: onTap,
    );
  }
  Widget createDrawerHeader() {
    return Container(color: color1,
      child: SafeArea(
        child: DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image:  AssetImage('images/Graphic1.png'))),
            child: Stack(children: <Widget>[
              // Positioned(
              //     bottom: 12.0,
              //     left: 16.0,
              //     child: Text("Welcome to Flutter",
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 20.0,
              //             fontWeight: FontWeight.w500))),
            ])),
      ),
    );
  }
}