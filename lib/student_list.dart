import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/student_create.dart';
import 'package:flutter_application_1/student_detail.dart';

class Student {
  final String id;
  final String name;
  final String batch;

  Student({required this.id, required this.name, required this.batch});
}

class StudentListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Student List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Student(
              id: doc.id, // Store the document ID for updates and deletes
              name: data['name'],
              batch: data['batch'],
            );
          }).toList();

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Container(
                padding: EdgeInsets.all(6),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text(student.name),
                  subtitle: Text(student.batch),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        child: Text("detail"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentViewPage(studentId: student.id,)),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Delete the student record from Firebase
                          FirebaseFirestore.instance
                              .collection('students')
                              .doc(student.id)
                              .delete()
                              .then((_) {
                            // Show a snackbar or perform other actions after deletion
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Student deleted successfully.'),
                              ),
                            );
                          }).catchError((error) {
                            // Handle errors if any
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error deleting student.'),
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentFormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
