import 'dart:async';
import 'package:cut_hair/Screen/Screen_user/screen_register.dart';
import 'package:cut_hair/Screen/screen_main(user).dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/profile.dart';

class Screen_login extends StatefulWidget {
  const Screen_login({super.key});

  @override
  State<Screen_login> createState() => _Screen_loginState();

}


class _Screen_loginState extends State<Screen_login> {
  //Profile profile = Profile();
  final formKey = GlobalKey<FormState>();
  final TextEditingController Username = TextEditingController();
  final TextEditingController Password = TextEditingController();
  bool passwordVisible = false;
  String currentUser = "";


  void initState() {
    super.initState();
    passwordVisible = true;

  } //password visible
  void chckUserenameAndPassword() async {
    await Firebase.initializeApp();
    final firestore = FirebaseFirestore.instance;
    final Users = Username.text;
    final Pass = Password.text;

    Stream<QuerySnapshot> snapshots = firestore.collection('User').where('Email', isEqualTo: Users).snapshots();
    snapshots.listen((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc['Email'].toString() == Users && doc['Password'].toString() == Pass && doc['Status'].toString() == "User") {
          String uid= doc.id;
          String email = doc['Email'];
          Profile.setUid(uid);
          Profile.setUsername(Users);
          Profile.setEmail(email);
          Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => MainScreen_user(MyCurrentIndex: 0,),
          ),
          );
          return; // Exit the function after successful login
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่พบบัญชีผู้ใช้ กรุณากรอกใหม่ให้ถูกต้อง',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Color(0xFF1C243C),
        ),
      );


    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA48369),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color: Color(0xFFEDECDF),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "lib/assets/images/Barber_1.png",
                        height: 150.0,
                      ),
                      SizedBox(height: 20.0),
                      Text(" Member Login",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: Username,
                        /*validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกข้อมูล';
                          }
                          return null;
                        }*/
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          //prefix: Icon(Icons.mail_outline),
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        obscureText: passwordVisible,
                        controller: Password,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          //prefix: Icon(Icons.lock_open_outlined),
                          suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              }
                          ),
        
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenRegister(),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'hero',
                          child: Text(
                            "ยังไม่ได้เป็นสมาชิกใช่ไหม? สมัครเลยตอนนี้",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      SizedBox(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              chckUserenameAndPassword();
                        },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF57B846), //background color of button
                              elevation: 3, //elevation of button
                              shape: RoundedRectangleBorder( //to set border radius to button
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              padding: EdgeInsets.all(20) //content padding inside button
                          ),
                            icon: Icon(Icons.login, color: Colors.white,),
                            label: Text(
                                "เข้าสู่ระบบ",
                                style: TextStyle(fontSize: 20,
                                  color: Colors.white,
                                ),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}