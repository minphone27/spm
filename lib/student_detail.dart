import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter_application_1/student_update.dart';

String generateRandomImageUrl() {
  final List<String> imageUrls = [
     'assets/images/ppl_logo1.jpg',
    'assets/images/ppl_logo2.jpg',
    'assets/images/ppl_logo3.jpg',
    'assets/images/ppl_logo4.jpg',
    'assets/images/ppl_logo5.jpg',
    'assets/images/ppl_logo6.jpg',
    'assets/images/ppl_logo7.jpg',
  ];

  final Random random = Random();
  final int randomIndex = random.nextInt(imageUrls.length);

  return imageUrls[randomIndex];
}


class StudentViewPage extends StatefulWidget {
  final String studentId;

  StudentViewPage({required this.studentId});

  @override
  _StudentViewPageState createState() => _StudentViewPageState();
}

class _StudentViewPageState extends State<StudentViewPage> {
  String? _studentName;
  String? _studentBatch;
  String? _studentPhoneNumber;
  String? _studentEmail;
  String? _studentDateOfBirth;

  void _fetchStudentData() {
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _studentName = data['name'];
          _studentBatch = data['batch'];
          _studentPhoneNumber = data['phone_number'];
          _studentEmail = data['email'];
          _studentDateOfBirth = data['date_of_birth'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Student Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // Add an edit icon button in the app bar
            onPressed: () {
              // Navigate to the student edit page when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentUpdateFormPage(studentId: widget.studentId),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: Image.asset(
                generateRandomImageUrl(),
                width: 100,
                height: 100,
              ),
            ),
            ListTile(
              title: Text('Name'),
              subtitle: Text(_studentName ?? 'Loading...'),
            ),
            ListTile(
              title: Text('Batch'),
              subtitle: Text(_studentBatch ?? 'Loading...'),
            ),
            ListTile(
              title: Text('Phone Number'),
              subtitle: Text(_studentPhoneNumber ?? 'Loading...'),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(_studentEmail ?? 'Loading...'),
            ),
            ListTile(
              title: Text('Date of Birth'),
              subtitle: Text(_studentDateOfBirth ?? 'Loading...'),
            ),
          ],
        ),
      ),
    );
  }
}
