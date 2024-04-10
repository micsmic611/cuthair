import 'package:cut_hair/Screen/Screen_user/screen_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/profile.dart';
import '../screen_login.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedHairType;
  String? selectedEmployee;
  DateTime? selectedDateTime;

  final TextEditingController _employeeController = TextEditingController();

  Future<void> _bookAppointment() async {
    if (selectedHairType != null &&
        selectedEmployee != null &&
        selectedDateTime != null) {
      // ตรวจสอบว่ามีการจองเวลาเดียวกันอยู่แล้วหรือไม่
      bool isTimeSlotAvailable = await _checkTimeSlot(selectedEmployee!, selectedDateTime!);

      if (!isTimeSlotAvailable) {
        // แสดงข้อความว่าเวลาที่เลือกถูกจองไปแล้ว
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('มีคนจองช่างเวลานี้แล้ว')),
        );
        return;
      }

      // เพิ่มข้อมูลการจองใน Firestore
      await FirebaseFirestore.instance.collection('Booking').add({
        'HairType': selectedHairType,
        'Employee': selectedEmployee,
        'DateTime': selectedDateTime,
        'User': Profile.Email,
      });

      // แสดงข้อความว่าจองสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('จองสำเร็จ')),
      );
    } else {
      // แสดงข้อความว่าต้องเลือกข้อมูลให้ครบถ้วน
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('จงกรอกข้อมูลให้ครบ')),
      );
    }
  }

  Future<bool> _checkTimeSlot(String employee, DateTime dateTime) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .where('Employee', isEqualTo: employee)
        .where('DateTime', isEqualTo: dateTime)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Screen_login()),
            );
          },
          icon: Icon(Icons.logout),
          color: Colors.white,
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "การจอง",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFA8886C),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePageCutHair()),
              );
            },
            icon: const Icon(Icons.info),
            color: Colors.white,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ประเภทบริการ',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('cut').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<String> hairTypes = [];
                  for (var doc in snapshot.data!.docs) {
                    String hairType = doc['type'];
                    hairTypes.add(hairType);
                  }

                  return DropdownButtonFormField(
                    items: hairTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedHairType = value as String?;
                      });
                    },
                    value: selectedHairType,
                    decoration: InputDecoration(
                      hintText: 'Select Hair Type',
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'ช่าง',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('employee').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DropdownMenuItem<String>> items = [];
                  for (var doc in snapshot.data!.docs) {
                    String employeeName = doc['name'];
                    items.add(
                      DropdownMenuItem(
                        value: employeeName,
                        child: Text(employeeName),
                      ),
                    );
                  }

                  return DropdownButtonFormField(
                    items: items,
                    onChanged: (value) {
                      setState(() {
                        selectedEmployee = value as String?;
                      });
                    },
                    value: selectedEmployee,
                    decoration: InputDecoration(
                      hintText: 'เลือกช่าง',
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'วันและเวลา',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDateTime != null) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      selectedDateTime = DateTime(
                        pickedDateTime.year,
                        pickedDateTime.month,
                        pickedDateTime.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              child: Text(selectedDateTime == null
                  ? 'เลือกวันและเวลา'
                  : 'เลือกวันและเวลา'),
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _bookAppointment,
                child: Text('จองเลย'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
