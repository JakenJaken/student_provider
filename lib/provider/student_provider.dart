import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/Student.dart';
import '../services/student_service.dart';

class StudentProvider with ChangeNotifier {
  final _service = StudentService();
  bool isLoading = false;
  List<Student> _students = [];
  List<Student> get students => _students;

  Future<List<Student>> getAllStudents(String token) async {
    isLoading = true;
    notifyListeners();

    final students = await _service.fetchData(token);

    _students = students ?? []; // If students is null, assign an empty list
    isLoading = false;
    notifyListeners();

    return _students;
  }

  Future<void> insertStudent(
      String token, String name, int? age, String profilePicturePath) async {
    final student = await _service.insertData(
      token,
      name,
      age ?? 0,
      profilePicturePath,
    );
    if (student != null) {
      _students.add(student);
      notifyListeners();
    } else {
      print('Failed to insert student.');
    }
  }

  Future<void> updateStudent(String token, int id, String name, int? age,
      String profilePicturePath) async {
    final student = await _service.updateData(
      token,
      id,
      name,
      age ?? 0,
      profilePicturePath,
    );
    if (student != null) {
      final index = _students.indexWhere((student) => student.id == id);
      if (index != -1) {
        _students[index] = student;
        notifyListeners();
      }
    } else {
      print('Failed to update student.');
    }
  }

  Future<bool> deleteStudent(String token, int id) async {
    try {
      await _service.deleteData(token, id);
      _students.removeWhere((student) => student.id == id);
      notifyListeners();
      return true; // Return true to indicate successful deletion
    } catch (e) {
      print('Exception occurred while deleting student: $e');
      return false; // Return false to indicate deletion failure
    }
  }
}
