import 'package:auth_ui/api/line_include.dart';

import 'line_item_in_list.dart';
import 'order_total_amount.dart';

class Add_order{

  String idempotency_key;
  String id;
  String location_id;
  List<Object> line_items;
  Order_total_amount total_amount;
  String customer_id;
  String order_state;


  factory Add_order.fromJson(Map<String, dynamic> json) {
    return Add_order(
      idempotency_key: json['idempotency_key'] as String,
      id: json['id'] as String,
      location_id: json['location_id'] as String,
      customer_id: json['customer_id'] as String,
      order_state: json['order_state'] as String,
      total_amount: Order_total_amount.fromJson(json['total_amount']),
      line_items: (json['line_items'] as List<dynamic>).map((dynamic e) => Line_include.fromJson(e as Map<String, dynamic>)).toList(),
      //object: json['object'] as Objects,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'idempotency_key': idempotency_key,
      'id': id,
      'location_id': location_id,
      'line_items' : line_items,
      'customer_id' : customer_id,
      'order_state' : order_state,
    };
  }


//<editor-fold desc="Data Methods">

  Add_order({
    required this.idempotency_key,
    required this.id,
    required this.location_id,
    required this.line_items,
    required this.total_amount,
    required this.customer_id,
    required this.order_state,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Add_order &&
          runtimeType == other.runtimeType &&
          idempotency_key == other.idempotency_key &&
          id == other.id &&
          location_id == other.location_id &&
          line_items == other.line_items &&
          total_amount == other.total_amount &&
          customer_id == other.customer_id &&
          order_state == other.order_state);

  @override
  int get hashCode =>
      idempotency_key.hashCode ^
      id.hashCode ^
      location_id.hashCode ^
      line_items.hashCode ^
      total_amount.hashCode ^
      customer_id.hashCode ^
      order_state.hashCode;

  @override
  String toString() {
    return 'Add_order{' +
        ' idempotency_key: $idempotency_key,' +
        ' id: $id,' +
        ' location_id: $location_id,' +
        ' line_items: $line_items,' +
        ' total_amount: $total_amount,' +
        ' customer_id: $customer_id,' +
        ' order_state: $order_state,' +
        '}';
  }

  Add_order copyWith({
    String? idempotency_key,
    String? id,
    String? location_id,
    List<Object>? line_items,
    Order_total_amount? total_amount,
    String? customer_id,
    String? order_state,
  }) {
    return Add_order(
      idempotency_key: idempotency_key ?? this.idempotency_key,
      id: id ?? this.id,
      location_id: location_id ?? this.location_id,
      line_items: line_items ?? this.line_items,
      total_amount: total_amount ?? this.total_amount,
      customer_id: customer_id ?? this.customer_id,
      order_state: order_state ?? this.order_state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idempotency_key': this.idempotency_key,
      'id': this.id,
      'location_id': this.location_id,
      'line_items': this.line_items,
      'total_amount': this.total_amount,
      'customer_id': this.customer_id,
      'order_state': this.order_state,
    };
  }

  factory Add_order.fromMap(Map<String, dynamic> map) {
    return Add_order(
      idempotency_key: map['idempotency_key'] as String,
      id: map['id'] as String,
      location_id: map['location_id'] as String,
      line_items: map['line_items'] as List<Object>,
      total_amount: map['total_amount'] as Order_total_amount,
      customer_id: map['customer_id'] as String,
      order_state: map['order_state'] as String,
    );
  }

//</editor-fold>
}