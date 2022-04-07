// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  ProfileModel({
    this.name,
    this.mobile,
    this.education,
    this.email,
    this.services,
    this.degrees,
    this.specialist,
    this.experience,
    this.photoBlob,
    this.ratings,
    this.reviews,
    this.lawyerID,
  });

  String name;
  String mobile;
  String education;
  String email;
  List<String> services;
  List<String> degrees;
  List<String> specialist;
  List<int> ratings;
  List<String> reviews;
  String experience;
  Blob photoBlob;
  String lawyerID;

  factory ProfileModel.fromJson(Map<String, dynamic> json, String id) => ProfileModel(
        name: json["name"],
        mobile: json["mobile"],
        education: json["education"],
        email: json["email"],
        ratings: List<int>.from(json["ratings"].map((x) => x)),
        reviews: List<String>.from(json["reviews"].map((x) => x)),
        services: List<String>.from(json["services"].map((x) => x)),
        degrees: List<String>.from(json["degrees"].map((x) => x)),
        specialist: List<String>.from(json["specialist"].map((x) => x)),
        experience: json["experience"],
        photoBlob: json["photoBlob"],
        lawyerID: id,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile": mobile,
        "education": education,
        "email": email,
        "services": List<dynamic>.from(services.map((x) => x)),
        "degrees": List<dynamic>.from(degrees.map((x) => x)),
        "specialist": List<dynamic>.from(specialist.map((x) => x)),
        "ratings": List<dynamic>.from(ratings.map((x) => x)),
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
        "experience": experience,
        "photoBlob": photoBlob,
      };
}
