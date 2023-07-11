import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_4/models/Student.dart';

import 'package:flutter_application_4/config/studentApi.dart';

class StudentService {
  Future<List<Student>?> fetchData(String? token) async {
    try {
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.get(
        Uri.parse(studentApi.studentsEndpoint),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final students = json.map((e) {
          return Student(
            id: e['id'],
            name: e['student_name'],
            age: e['student_age'],
            profilePicture: e['profile_picture'],
          );
        }).toList();

        return students;
      } else {
        print('Failed to fetch data. Error: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred while fetching data: $e');
    }
    return null;
  }

  Future<Student?> insertData(
    String? token,
    String name,
    int? age,
    String profilePicturePath,
  ) async {
    try {
      if (token == null) {
        throw Exception('Token is null');
      }

      final url = Uri.parse(studentApi.studentsEndpoint);
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['student_name'] = name;
      request.fields['student_age'] =
          age?.toString() ?? ''; // Ensure it's an empty string if age is null
      if (profilePicturePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profilePicturePath,
        ));
      }

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final student = Student(
          id: json['id'],
          name: json['student_name'],
          age: int.parse(json['student_age'].toString()),
          profilePicture: json['profile_picture'],
        );
        return student;
      } else {
        print(
            'Failed to insert student. Error: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      print('Exception occurred while inserting student: $e');
    }
    return null;
  }

  Future<Student?> updateData(
    String? token,
    int id,
    String name,
    int? age,
    String profilePicturePath,
  ) async {
    try {
      if (token == null) {
        throw Exception('Token is null');
      }

      final url = Uri.parse('${studentApi.studentsEndpoint}/update');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['id'] = id.toString();
      request.fields['student_name'] = name;
      request.fields['student_age'] = age.toString();
      if (profilePicturePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profilePicturePath,
        ));
      }

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final student = Student(
          id: json['id'],
          name: json['student_name'],
          age: int.parse(json['student_age'].toString()),
          profilePicture: json['profile_picture'],
        );
        return student;
      } else {
        print(
            'Failed to update student. Error: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      print('Exception occurred while updating student: $e');
    }
    return null;
  }

  Future<void> deleteData(String? token, int id) async {
    try {
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.delete(
        Uri.parse('${studentApi.studentsEndpoint}/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print('Data deleted successfully');
      } else {
        print('Failed to delete data. Error: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred while deleting data: $e');
    }
  }
}
