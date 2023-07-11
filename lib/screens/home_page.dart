import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_4/provider/student_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../models/Student.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = '';
  int? age = 0;
  File? profilePicture;
  bool showUploadButton = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StudentProvider>(context, listen: false)
          .getAllStudents(widget.token)
          .then((students) {});
    });
  }

  String getProfilePictureUrl(Student student) {
    String baseUrl = 'http://localhost:8000';
    String relativeUrl = student.profilePicture;
    return '$baseUrl$relativeUrl';
  }

  Future<void> _showDetailStudentDialog(
      BuildContext context, dynamic student) async {
    String imageUrl = getProfilePictureUrl(student);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.white,
          title: const Text('Student Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Name: ${student.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Age: ${student.age}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                width: 200,
                height: 200,
                child: QrImageView(data: student.id.toString()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddStudentDialog(BuildContext context,
      {Student? student}) async {
    name = student?.name ?? '';
    age = student?.age;
    profilePicture = null;
    showUploadButton = true;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              backgroundColor: Colors.white,
              title: Text(student != null ? 'Edit Student' : 'Add Student'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => name = value,
                    controller: TextEditingController(text: name),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Age',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final parsedAge = int.tryParse(value);
                      if (parsedAge != null) {
                        setState(() {
                          age = parsedAge;
                        });
                      }
                      print(parsedAge);
                    },
                    controller:
                        TextEditingController(text: age?.toString() ?? ''),
                  ),
                  const SizedBox(height: 16.0),
                  if (profilePicture != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.grey[500],
                                size: 36.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                profilePicture!.path,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                profilePicture = null;
                                showUploadButton = true;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (showUploadButton)
                    InkWell(
                      onTap: () async {
                        final pickedImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedImage != null) {
                          setState(() {
                            profilePicture = File(pickedImage.path);
                            showUploadButton = false;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.grey[500],
                              size: 36.0,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Upload Profile Picture',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final studentProvider =
                        Provider.of<StudentProvider>(context, listen: false);
                    if (student != null) {
                      studentProvider.updateStudent(widget.token, student.id,
                          name, age ?? 0, profilePicture?.path ?? '');
                    } else {
                      studentProvider.insertStudent(widget.token, name,
                          age ?? 0, profilePicture?.path ?? '');
                    }
                    studentProvider
                        .getAllStudents(widget.token)
                        .then((students) {});
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider API'),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final students = value.students;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              String imageUrl = getProfilePictureUrl(student);
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  leading: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Age: ${student.age}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.info,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          _showDetailStudentDialog(context, student);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          _showAddStudentDialog(context, student: student);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmation"),
                                content: const Text(
                                    "Are you sure you want to proceed?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          false); // Return false to indicate cancellation
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Proceed"),
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          true); // Return true to indicate confirmation
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((confirmed) {
                            if (confirmed != null && confirmed) {
                              Provider.of<StudentProvider>(context,
                                      listen: false)
                                  .deleteStudent(widget.token, student.id)
                                  .then((value) {
                                if (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Delete student success'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Delete student failed'),
                                    ),
                                  );
                                }
                              });
                            } else {}
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
        onPressed: () => _showAddStudentDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
