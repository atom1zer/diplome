import 'package:flutter/src/material/data_table.dart';

class Model_order{

  String id;
  String id_from_catalog_item;
  String name;
  String descriptions;
  int quantity;
  int price;
  int value;
  bool is_customize;

//<editor-fold desc="Data Methods">

  Model_order({
    required this.id,
    required this.id_from_catalog_item,
    required this.name,
    required this.descriptions,
    required this.quantity,
    required this.price,
    required this.value,
    required this.is_customize,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Model_order &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          id_from_catalog_item == other.id_from_catalog_item &&
          name == other.name &&
          descriptions == other.descriptions &&
          quantity == other.quantity &&
          price == other.price &&
          value == other.value &&
          is_customize == other.is_customize);

  @override
  int get hashCode =>
      id.hashCode ^
      id_from_catalog_item.hashCode ^
      name.hashCode ^
      descriptions.hashCode ^
      quantity.hashCode ^
      price.hashCode ^
      value.hashCode ^
      is_customize.hashCode;

  @override
  String toString() {
    return 'Model_order{' +
        ' id: $id,' +
        ' id_from_catalog_item: $id_from_catalog_item,' +
        ' name: $name,' +
        ' descriptions: $descriptions,' +
        ' quantity: $quantity,' +
        ' price: $price,' +
        ' value: $value,' +
        ' is_customize: $is_customize,' +
        '}';
  }

  Model_order copyWith({
    String? id,
    String? id_from_catalog_item,
    String? name,
    String? descriptions,
    int? quantity,
    int? price,
    int? value,
    bool? is_customize,
  }) {
    return Model_order(
      id: id ?? this.id,
      id_from_catalog_item: id_from_catalog_item ?? this.id_from_catalog_item,
      name: name ?? this.name,
      descriptions: descriptions ?? this.descriptions,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      value: value ?? this.value,
      is_customize: is_customize ?? this.is_customize,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'id_from_catalog_item': this.id_from_catalog_item,
      'name': this.name,
      'descriptions': this.descriptions,
      'quantity': this.quantity,
      'price': this.price,
      'value': this.value,
      'is_customize': this.is_customize,
    };
  }

  factory Model_order.fromMap(Map<String, dynamic> map) {
    return Model_order(
      id: map['id'] as String,
      id_from_catalog_item: map['id_from_catalog_item'] as String,
      name: map['name'] as String,
      descriptions: map['descriptions'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as int,
      value: map['value'] as int,
      is_customize: map['is_customize'] as bool,
    );
  }

//</editor-fold>
}