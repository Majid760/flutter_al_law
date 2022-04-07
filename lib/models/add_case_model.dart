// To parse this JSON data, do
//
//     final caseModel = caseModelFromJson(jsonString);

import 'dart:convert';

CaseModel caseModelFromJson(String str) => CaseModel.fromJson(json.decode(str));

String caseModelToJson(CaseModel data) => json.encode(data.toJson());

class CaseModel {
  CaseModel({
    this.caseID,
    this.clientName,
    this.caseName,
    this.caseNumber,
    this.caseRemarks,
    this.caseDate,
    this.caseType,
    this.caseCharges,
    this.casePetitioner,
    this.caseDesc,
    this.courtName,
    this.courtCity,
    this.judgeName,
  });

  String caseID;
  String clientName;
  String caseName;
  String caseNumber;
  String caseRemarks;
  DateTime caseDate;
  String caseType;
  double caseCharges;
  String casePetitioner;
  String caseDesc;
  String courtName;
  String courtCity;
  String judgeName;

  factory CaseModel.fromJson(Map<String, dynamic> json) => CaseModel(
        caseID: json["case_id"],
        clientName: json["client_name"],
        caseName: json["case_name"],
        caseNumber: json["case_number"],
        caseRemarks: json["case_remarks"],
        caseDate: DateTime.parse(json["case_date"]),
        caseType: json["case_type"],
        caseCharges: json["case_charges"].toDouble(),
        casePetitioner: json["case_petitioner"],
        caseDesc: json["case_desc"],
        courtName: json["court_name"],
        courtCity: json["court_city"],
        judgeName: json["judge_name"],
      );

  Map<String, dynamic> toJson() => {
        "case_id": caseID,
        "client_name": clientName,
        "case_name": caseName,
        "case_number": caseNumber,
        "case_remarks": caseRemarks,
        "case_date":
            "${caseDate.year.toString().padLeft(4, '0')}-${caseDate.month.toString().padLeft(2, '0')}-${caseDate.day.toString().padLeft(2, '0')}",
        "case_type": caseType,
        "case_charges": caseCharges,
        "case_petitioner": casePetitioner,
        "case_desc": caseDesc,
        "court_name": courtName,
        "court_city": courtCity,
        "judge_name": judgeName,
      };
}
