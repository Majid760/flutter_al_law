//User Model
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String mobile;
  final String experience;
  final String education;
  final String photoUrl;
  final Blob photoBlob;
  final List<String> services;
  final List<String> degrees;
  final List<String> specialist;

  UserModel({
    @required this.uid,
    @required this.email,
    @required this.name,
    @required this.mobile,
    @required this.experience,
    @required this.education,
    @required this.photoUrl,
    @required this.photoBlob,
    @required this.services,
    @required this.degrees,
    @required this.specialist,
  });

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      mobile: data['mobile'] ?? '',
      experience: data['experience'] ?? '',
      education: data['education'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      photoBlob: data['photoBlob'],
      services: List<String>.from(data["services"].map((x) => x)),
      degrees: List<String>.from(data["degrees"].map((x) => x)),
      specialist: List<String>.from(data["specialist"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "mobile": mobile,
        "experience": experience,
        "education": education,
        "photoUrl": photoUrl,
        "photoBlob": photoBlob,
        "services": List<dynamic>.from(services.map((x) => x)),
        "degrees": List<dynamic>.from(degrees.map((x) => x)),
        "specialist": List<dynamic>.from(specialist.map((x) => x)),
      };
}
