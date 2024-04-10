import 'package:cut_hair/Screen/Screen_user/reserve_choose_type.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cut_hair/model/profile.dart';

class ProfilePageCutHair extends StatefulWidget {
  const ProfilePageCutHair({Key? key}) : super(key: key);

  @override
  _ProfilePageCutHairState createState() => _ProfilePageCutHairState();
}

class _ProfilePageCutHairState extends State<ProfilePageCutHair> {
  String? username;
  String? firstname;
  String? lastname;
  String? phone;
  String? email;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkUserProfile();
  }

  void _checkUserProfile() async {
    String? userEmail = Profile.Email;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('Email', isEqualTo: userEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        username = querySnapshot.docs.first['Username'];
        firstname = querySnapshot.docs.first['Firstname'];
        lastname = querySnapshot.docs.first['Lastname'];
        phone = querySnapshot.docs.first['Phone'];
        email = querySnapshot.docs.first['Email'];

        _usernameController.text = username ?? '';
        _firstnameController.text = firstname ?? '';
        _lastnameController.text = lastname ?? '';
        _phoneController.text = phone ?? '';
      });
    }
  }

  void _updateProfile() async {
    String? newUsername = _usernameController.text;
    String? newFirstname = _firstnameController.text;
    String? newLastname = _lastnameController.text;
    String? newPhone = _phoneController.text;

    String? userEmail = Profile.Email;
    final userDoc = FirebaseFirestore.instance.collection('User').doc(userEmail);

    if (newUsername == _usernameController.text) await userDoc.update({'Username': newUsername});
    if (newFirstname == _firstnameController.text) await userDoc.update({'Firstname': newFirstname});
    if (newLastname == _lastnameController.text) await userDoc.update({'Lastname': newLastname});
    if (newPhone == _phoneController.text) await userDoc.update({'Phone': newPhone});

    setState(() {
      username = newUsername;
      firstname = newFirstname;
      lastname = newLastname;
      phone = newPhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BookingPage()));
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: Text("โปรไฟล์"),
        backgroundColor: Color(0xFFA48369),
      ),
      body: Container(
        color: Color(0xFFEDECDF),
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "lib/assets/images/Barber_1.png",
                height: 150.0,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _firstnameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _lastnameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
