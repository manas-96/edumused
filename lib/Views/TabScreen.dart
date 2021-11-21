import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hemchaya_education/Views/OrderList.dart';
import 'package:hemchaya_education/Views/Profile.dart';
import 'package:hemchaya_education/Views/WishList.dart';
import 'package:hemchaya_education/helper.dart';

import 'Cart.dart';
import 'Dashboard.dart';




class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _currentIndex = 0;

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
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
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
            ],
          );
        });
  }
  final List<Widget> _children = [
    Dashboard(),
    Cart(),
    WishList(),
    Profile()
  ];


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onBackPressed,
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            splashColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Get.to(OrderList());
            },
            tooltip: 'Order',
            child: Icon(Icons.shopping_bag_outlined,color: Colors.white,),
            elevation: 10.0,
          ),
          body: _children[_currentIndex],


          bottomNavigationBar:  BottomAppBar(
            elevation: 10,
            color: Colors.white,
            notchMargin: 6.0,
            clipBehavior: Clip.antiAlias,
            shape: CircularNotchedRectangle(),
            child: BottomNavigationBar(

              selectedItemColor: Theme.of(context).primaryColor,
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  // backgroundColor: white,
                  icon: new Icon(Icons.home,),
                  title: new Text('Home',style: TextStyle(fontSize: 13,color: Colors.white),),
                ),
                BottomNavigationBarItem(

                  icon: new Icon(Icons.shopping_cart),
                  title: new Text('Cart',style: TextStyle(fontSize: 13,color: white),),
                ),
                BottomNavigationBarItem(

                    icon: Icon(Icons.favorite),
                    title: Text('WishList',style: TextStyle(fontSize: 13,color: white),)),
                BottomNavigationBarItem(

                    icon: Icon(Icons.person),
                    title: Text('Profile',style: TextStyle(fontSize: 13,color: white),)),

              ],
            ),
          )
      ),
    );
  }
}