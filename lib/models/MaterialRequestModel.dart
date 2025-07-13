import 'dart:convert';
import 'dart:io';
class Materialrequestmodel {
  String?id;
  String? search;
  String? status;
  String? startDate;
  String? endDate;

  Materialrequestmodel({
    this.id,
    this.search,
    this.status,
    this.startDate,
    this.endDate,
  });

  Materialrequestmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
  @override
  String toString() {
    return 'Materialrequestmodel{id: $id, status: $status, startDate: $startDate, endDate: $endDate}';
  }
}