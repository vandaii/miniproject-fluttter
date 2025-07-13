import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class DirectPurchaseModel {
  final int id;
  final String purchaseNumber;
  final String supplierName;
  final DateTime purchaseDate;
  final double totalAmount;
  final String status;

  DirectPurchaseModel({
    required this.id,
    required this.purchaseNumber,
    required this.supplierName,
    required this.purchaseDate,
    required this.totalAmount,
    required this.status,
  });

  factory DirectPurchaseModel.fromJson(Map<String, dynamic> json) {
    return DirectPurchaseModel(
      id: json['id'],
      purchaseNumber: json['purchase_number'],
      supplierName: json['supplier_name'],
      purchaseDate: DateTime.parse(json['purchase_date']),
      totalAmount: json['total_amount'].toDouble(),
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchase_number': purchaseNumber,
      'supplier_name': supplierName,
      'purchase_date': purchaseDate.toIso8601String(),
      'total_amount': totalAmount,
      'status': status,
    };
  }
}
