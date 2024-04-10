import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cut_hair/component/mytextfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cut_hair/component/button.dart';

import '../screen_login.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final phoneTextController = TextEditingController();

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("User");

  Future savingUserData(String email, String username,String firstname,String lastname,String phone,String password) async {
    DocumentReference docRef = userCollection.doc(); // สร้างอ้างอิงไปยังเอกสารใหม่โดยไม่ระบุ Document ID
    String uid = docRef.id; // กำหนดค่า uid เป็นค่า ID ของเอกสารนี้
    await docRef.set({
      'Email': email,
      'Username': username,
      'Status': "User",
      'Firstname': firstname,
      'Lastname': lastname,
      'Phone': phone,
      'Password':password,
      'Uid': uid
    });
  }

  void signUp() {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      if (emailTextController.text.isEmpty) {
        displayMessage("กรุณากรอก อีเมล");
        return;
      }
      if (passwordTextController.text.isEmpty) {
        displayMessage("กรุณากรอก password");
        return;
      }
      if (confirmPasswordTextController.text.isEmpty) {
        displayMessage("กรุณากรอก password อีกครั้ง");
        return;
      }
      if (firstNameTextController.text.isEmpty) {
        if(firstNameTextController.text.length > 25) {
          displayMessage("ชื่อ 25 ตัวอักษร");
          return;
        }
        displayMessage("กรุณากรอก ชื่อ");
        return;
      }
      if (lastNameTextController.text.isEmpty) {
        if(lastNameTextController.text.length > 30) {
          displayMessage("ชื่อ 30 ตัวอักษร");
          return;
        }
        displayMessage("กรุณากรอก นามสกุล");
        return;
      }

      if (passwordTextController.text != confirmPasswordTextController.text) {
        Navigator.pop(context);
        displayMessage("กรอก password ให้เหมือนกัน!!");
        return;
      }

      if (!isPhoneNumberValid(phoneTextController.text)) {
        Navigator.pop(context);
        displayMessage("เบอร์โทรไม่ถูกต้อง");
        return;
      }

      savingUserData(
        emailTextController.text,
        emailTextController.text.split('@')[0],
        firstNameTextController.text,
        lastNameTextController.text,
        phoneTextController.text,
        passwordTextController.text,
      );
      Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context) => Screen_login(),
      ),
      );
    } catch (error) {
      print('Firebase error: $error');
      Navigator.pop(context); // ปิด Dialog เมื่อเกิดข้อผิดพลาด
      displayMessage("เกิดข้อผิดพลาดจาก Firebase");
    }
  }

  bool isPhoneNumberValid(String phoneNumber) {
    RegExp regex = RegExp(r'^[0-9]{10}$');
    return regex.hasMatch(phoneNumber);
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ปิด AlertDialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA48369),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFEDECDF),
                    borderRadius: BorderRadius.circular(8),),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('lib/assets/images/Barber_1.png', width: 300, height: 250),
                      Container(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'อีเมลล์',
                              ),
                              controller: emailTextController,
                              obscureText: false,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: passwordTextController,
                              decoration: InputDecoration(
                                hintText: 'รหัสผ่าน',
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: confirmPasswordTextController,
                              decoration: InputDecoration(
                                hintText: 'ยืนยันรหัสผ่านอีกครั้ง',
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: firstNameTextController,
                              decoration: InputDecoration(
                                hintText: 'ชื่อจริง',
                              ),
                              obscureText: false,
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: lastNameTextController,
                              decoration: InputDecoration(
                                hintText: 'นามสกุล',
                              ),
                              obscureText: false,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: phoneTextController,
                              decoration: InputDecoration(
                                hintText: 'เบอร์โทร',
                              ),
                              obscureText: false,
                            ),
                          ],
                        ),
                      ),
                        const SizedBox(height: 15),
                        MyButton(
                          onTap: signUp,
                          text: 'Log in',
                        ),
                      ],
                    ),
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
