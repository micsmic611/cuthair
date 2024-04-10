import 'package:cut_hair/Screen/Screen_user/history.dart';
import 'package:cut_hair/Screen/Screen_user/reserve_choose_type.dart';
import 'package:cut_hair/Screen/Screen_user/review.dart';
import 'package:flutter/material.dart';



class MainScreen_user extends StatefulWidget {
  final int MyCurrentIndex;
  const MainScreen_user({super.key,required this.MyCurrentIndex});
  @override
  State<MainScreen_user> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen_user> {
  late String currentUse;
  late int MyCurrentIndex;
  late List pages;

  @override
  void initState() {
    super.initState();
    MyCurrentIndex = widget.MyCurrentIndex;
    pages = [BookingPage(), ReviewPage(), History_user(),];
  }
  @override
  Widget build(BuildContext context) {
    Widget MyNavBar = BottomNavigationBar(
        backgroundColor: Color(0xFFEDECDF),
        selectedItemColor: Color(0xFFA8886C),
        unselectedItemColor: Color(0xFF000000),
        currentIndex: MyCurrentIndex,
        onTap: (int index){
          setState(() {
            MyCurrentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.black),label: 'จองใช้บริการ'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper,color: Colors.black),label: 'รีวิว'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add,color: Colors.black),label: 'ประวัติ'),
        ]);

    return Scaffold(
      backgroundColor:Colors.white,
      body: pages[MyCurrentIndex],
      bottomNavigationBar: MyNavBar,
    );
  }
}