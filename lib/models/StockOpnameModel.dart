import 'dart:convert';
import 'dart:io';

class StockOpnameModel {
  int? id;
  String? stock_opname_number;
  DateTime? stock_opname_date;
  DateTime? input_stock_date;
  String? counted_by;
  String? prepared_by;
  String? status;


 

  StockOpnameModel({
    this.id,
    this.stock_opname_number,
    this.stock_opname_date,
    this.input_stock_date,
    this.counted_by,
    this.prepared_by,
    this.status,
  });

  factory StockOpnameModel.fromJson(Map<String, dynamic> json) {
    return StockOpnameModel(
      id: json['id'],
      stock_opname_number: json['stock_opname_number'],
      stock_opname_date: json['stock_opname_date'] != null
          ? DateTime.parse(json['stock_opname_date'])
          : null,
      input_stock_date: json['input_stock_date'] != null
          ? DateTime.parse(json['input_stock_date'])
          : null,
      counted_by: json['counted_by'],
      prepared_by: json['prepared_by'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock_opname_number': stock_opname_number,
      'stock_opname_date': stock_opname_date?.toIso8601String(),
      'input_stock_date': input_stock_date?.toIso8601String(),
      'counted_by': counted_by,
      'prepared_by': prepared_by,
      'status': status,
    };
  }
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
