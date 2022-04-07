import 'dart:convert';

ClientModel clientModelFromJson(String str) => ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel {
  ClientModel({
    this.id,
    this.name,
    this.address,
    this.contact,
    this.email,
    this.city,
    this.remarks,
  });

  String id;
  String name;
  String address;
  String contact;
  String email;
  String city;
  String remarks;

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["client_id"],
        name: json["client_name"],
        contact: json["client_contact"],
        email: json["client_email"],
        address: json["client_address"],
        city: json["client_city"],
        remarks: json["client_remarks"],
      );

  Map<String, dynamic> toJson() => {
        "client_id": id,
        "client_name": name,
        "client_contact": contact,
        "client_email": email,
        "client_address": address,
        "client_city": city,
        "client_remarks": remarks,
      };
}
