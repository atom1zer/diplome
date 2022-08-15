import 'dart:ffi';
import 'objects.dart';


class Catalog{
  List<Objects> objects;
 // Objects object;


  /*Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'object' : object.map((e) => e.toJson()).toList(),
    };
  }*/

  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(
      objects: (json['data'] as List<dynamic>).map((dynamic e) => Objects.fromJson(e as Map<String, dynamic>)).toList(),
      //object: json['object'] as Objects,
    );
  }

//<editor-fold desc="Data Methods">

  /*Catalog({
    required this.object,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Catalog &&
          runtimeType == other.runtimeType &&
          object == other.object);

  @override
  int get hashCode => object.hashCode;

  @override
  String toString() {
    return 'Catalog{' + ' object: $object,' + '}';
  }

  Catalog copyWith({
    Objects? object,
  }) {
    return Catalog(
      object: object ?? this.object,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'object': this.object,
    };
  }

  factory Catalog.fromMap(Map<String, dynamic> map) {
    return Catalog(
      object: map['object'] as Objects,
    );
  }*/

Catalog({
    required this.objects,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Catalog &&
          runtimeType == other.runtimeType &&
          objects == other.objects);

  @override
  int get hashCode => objects.hashCode;

  @override
  String toString() {
    return 'Catalog{' + ' object: $objects,' + '}';
  }

  Catalog copyWith({
    List<Objects>? object,
  }) {
    return Catalog(
      objects: object ?? this.objects,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'object': this.objects,
    };
  }

  factory Catalog.fromMap(Map<String, dynamic> map) {
    return Catalog(
      objects: map['object'] as List<Objects>,
    );
  }

}