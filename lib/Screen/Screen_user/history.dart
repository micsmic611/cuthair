import 'package:cut_hair/Screen/Screen_user/screen_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cut_hair/model/profile.dart';

import '../screen_login.dart';

class History_user extends StatefulWidget {
  const History_user({super.key});

  @override
  State<History_user> createState() => _History_userState();
}

class _History_userState extends State<History_user> {
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
          "ประวัติทำรายการ",
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Booking')
            .where('User', isEqualTo: Profile.Email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final bookings = snapshot.data!.docs;
            return ListView.builder(

              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index].data() as Map<String, dynamic>;
                final DateTime bookingDateTime = booking['DateTime'].toDate();
                final bool isFutureBooking = bookingDateTime.isAfter(DateTime.now());
                return ListTile(
                  title: Text('Hair Type: ${booking['HairType']}'),
                  subtitle: Text('Employee: ${booking['Employee']}'),
                  trailing: Text('Date & Time: ${bookingDateTime.toString()}'),
                  tileColor: isFutureBooking ? Colors.white : Colors.grey[300],
                  onTap: () {
                    _showDeleteConfirmationDialog(context, bookings[index].id);
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      backgroundColor: Color(0xFFEDECDF),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String bookingId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยกเลิกการจอง'),
          content: Text('คุณต้องการที่จะยกเลิกใช่มั้ย'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('Booking').doc(bookingId).delete();
                Navigator.of(context).pop();
              },
              child: Text(
                'ลบ',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
