import 'package:cut_hair/Screen/Screen_user/screen_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cut_hair/model/profile.dart';
import '../screen_login.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _reviewController = TextEditingController();
  late FirebaseFirestore _firestore;
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _getReviews();
  }

  void _getReviews() async {
    QuerySnapshot querySnapshot =
    await _firestore.collection('reviews').get();
    List<Review> reviews = [];
    querySnapshot.docs.forEach((doc) {
      String text = doc['text'];
      String userEmail = doc['userEmail'];
      Review review = Review(text: text, userEmail: userEmail);
      reviews.add(review);
    });
    setState(() {
      _reviews = reviews;
    });
  }

  void _postReview(String text) async {
    String userEmail = Profile.Email ?? 'Unknown';
    await _firestore.collection('reviews').add({
      'text': text,
      'userEmail': userEmail,
    });
    _getReviews();
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
          " รีวิว ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFA8886C),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ProfilePageCutHair()));
            },
            icon: const Icon(Icons.info),
            color: Colors.white,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(_reviews[index].text),
                    subtitle: Text(_reviews[index].userEmail),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: 'มารีวิวกันเถอะ',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String reviewText = _reviewController.text;
                    _postReview(reviewText);
                    _reviewController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
