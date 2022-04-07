import 'dart:convert';

ScheduleModel scheduleModelFromJson(String str) => ScheduleModel.fromJson(json.decode(str));

String scheduleModelToJson(ScheduleModel data) => json.encode(data.toJson());

class ScheduleModel {
  ScheduleModel({
    this.id,
    this.type,
    this.title,
    this.dateTime,
    this.detail,
    this.remarks,
    this.notificationTag,
  });

  String id;
  String type;
  String title;
  DateTime dateTime;
  String detail;
  String remarks;
  String notificationTag;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        id: json["schedule_id"],
        type: json["schedule_type"],
        title: json["schedule_title"],
        dateTime: DateTime.parse(json["schedule_dateTime"]),
        detail: json["schedule_detail"],
        remarks: json["schedule_remarks"],
        notificationTag: json["notification_tag"],
      );

  Map<String, dynamic> toJson() => {
        "schedule_id": id,
        "schedule_type": type,
        "schedule_title": title,
        "schedule_dateTime": dateTime.toString(),
        "schedule_detail": detail,
        "schedule_remarks": remarks,
        "notification_tag": notificationTag,
      };
}
