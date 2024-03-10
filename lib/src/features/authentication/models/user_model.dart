import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String? password; // Optional, consider security implications
  final String fullName;
  final String phoneNo;

  UserModel({
    required this.email,
    this.password,
    required this.fullName,
    required this.phoneNo,
  });

  static UserModel empty() {
    return UserModel(
      email: '',
      fullName: '',
      phoneNo: '',
      password: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNo': phoneNo,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return UserModel(
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNo: data['phoneNo'] ?? '',
    );
  }
}
