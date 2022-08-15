import 'dart:convert';

import 'catalog_reports.dart';

class List_reports{

 final List<In_catalog_reports> in_catalog_reports;
 List_reports({required this.in_catalog_reports});

   /*factory List_reports.fromJson(List<dynamic> json) =>
       List_reports(json.map((e) => In_catalog_reports.fromJson(e)).toList());*/


 factory List_reports.fromJson(List<dynamic> json) =>
     List_reports(in_catalog_reports: json.map((/*dynamic*/ e) => In_catalog_reports.fromJson(e /*as Map<String, dynamic>*/)).toList());

 /*factory List_reports.fromJson(Map<String, dynamic> json) {
   return List_reports(
     in_catalog_reports: (json[''] as List<dynamic>).map((dynamic e) => In_catalog_reports.fromJson(e as Map<String, dynamic>)).toList(),
     //object: json['object'] as Objects,
   );
 }*/

 /*Map<String, dynamic> toJson() {
   return <String, dynamic>{
     '': in_catalog_reports,
   };
 }*/


//<editor-fold desc="Data Methods">

 /* List_reports({
    required this.in_catalog_reports,
  });*/
/*
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is List_reports &&
          runtimeType == other.runtimeType &&
          in_catalog_reports == other.in_catalog_reports);

  @override
  int get hashCode => in_catalog_reports.hashCode;

  @override
  String toString() {
    return 'List_reports{' + ' in_catalog_reports: $in_catalog_reports,' + '}';
  }*/
/*
  List_reports copyWith({
    List<In_catalog_reports>? in_catalog_reports,
  }) {
    return List_reports(
      in_catalog_reports: in_catalog_reports ?? this.in_catalog_reports,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'in_catalog_reports': this.in_catalog_reports,
    };
  }

  factory List_reports.fromMap(Map<String, dynamic> map) {
    return List_reports(
      in_catalog_reports: map['in_catalog_reports'] as List<In_catalog_reports>,
    );
  }*/

//</editor-fold>
}