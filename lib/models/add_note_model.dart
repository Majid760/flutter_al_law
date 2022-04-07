import 'dart:convert';

NoteModel noteModelFromJson(String str) => NoteModel.fromJson(json.decode(str));

String noteModelToJson(NoteModel data) => json.encode(data.toJson());

class NoteModel {
  NoteModel({
    this.id,
    this.type,
    this.title,
    this.dateTime,
    this.detail,
  });

  String id;
  String type;
  String title;
  DateTime dateTime;
  String detail;

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json["note_id"],
        type: json["note_type"],
        title: json["note_title"],
        dateTime: _getDateTime(json["note_dateTime"]),
        detail: json["note_detail"],
      );

  Map<String, dynamic> toJson() => {
        "note_id": id,
        "note_type": type,
        "note_title": title,
        "note_dateTime": dateTime.toString(),
        "note_detail": detail,
      };

  static _getDateTime(String noteTime) {
    try {
      return DateTime.parse(noteTime);
    } catch (e) {
      print(e);
    }
  }
}
