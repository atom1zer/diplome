import 'package:auth_ui/api/line_include.dart';
import 'package:auth_ui/api/parse_line_items.dart';

import 'line_item_in_list.dart';
import 'location.dart';
import 'order_total_amount.dart';

class Order{

  String id;
  Location location;
  String reference_id;
  List<Parse_line_items> line_items;
  Order_total_amount total_amount;
  String customer_id;
  String order_state;


  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      location: Location.fromJson(json['location']),
      reference_id: json['reference_id'] as String,
      customer_id: json['customer_id'] as String,
      order_state: json['order_state'] as String,
      total_amount: Order_total_amount.fromJson(json['total_amount']),
      line_items: (json['line_items'] as List<dynamic>).map((dynamic e) => Parse_line_items.fromJson(e as Map<String, dynamic>)).toList(),
      //object: json['object'] as Objects,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'location': location,
      'reference_id': reference_id,
      'line_items' : line_items,
      'customer_id' : customer_id,
      'order_state' : order_state,
    };
  }


//<editor-fold desc="Data Methods">

  Order({
    required this.id,
    required this.location,
    required this.reference_id,
    required this.line_items,
    required this.total_amount,
    required this.customer_id,
    required this.order_state,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          location == other.location &&
          reference_id == other.reference_id &&
          line_items == other.line_items &&
          total_amount == other.total_amount &&
          customer_id == other.customer_id &&
          order_state == other.order_state);

  @override
  int get hashCode =>
      id.hashCode ^
      location.hashCode ^
      reference_id.hashCode ^
      line_items.hashCode ^
      total_amount.hashCode ^
      customer_id.hashCode ^
      order_state.hashCode;

  @override
  String toString() {
    return 'Order{' +
        ' id: $id,' +
        ' location: $location,' +
        ' reference_id: $reference_id,' +
        ' line_items: $line_items,' +
        ' total_amount: $total_amount,' +
        ' customer_id: $customer_id,' +
        ' order_state: $order_state,' +
        '}';
  }

  Order copyWith({
    String? id,
    Location? location,
    String? reference_id,
    List<Parse_line_items>? line_items,
    Order_total_amount? total_amount,
    String? customer_id,
    String? order_state,
  }) {
    return Order(
      id: id ?? this.id,
      location: location ?? this.location,
      reference_id: reference_id ?? this.reference_id,
      line_items: line_items ?? this.line_items,
      total_amount: total_amount ?? this.total_amount,
      customer_id: customer_id ?? this.customer_id,
      order_state: order_state ?? this.order_state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'location': this.location,
      'reference_id': this.reference_id,
      'line_items': this.line_items,
      'total_amount': this.total_amount,
      'customer_id': this.customer_id,
      'order_state': this.order_state,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      location: map['location'] as Location,
      reference_id: map['reference_id'] as String,
      line_items: map['line_items'] as List<Parse_line_items>,
      total_amount: map['total_amount'] as Order_total_amount,
      customer_id: map['customer_id'] as String,
      order_state: map['order_state'] as String,
    );
  }

//</editor-fold>
}