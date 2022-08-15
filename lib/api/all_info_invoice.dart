import 'package:auth_ui/api/subscription_details.dart';

import 'add_order.dart';
import 'invoice_activity.dart';
import 'order.dart';


class All_info_invoice{

 /* Order order = Order(id: '', location_id: '',
      reference_id: '', line_items: line_items,
      total_amount: total_amount, customer_id: '', order_state: '');*/

  List<Invoice_activity> invoice_activities;
  Order? order_details /*= Order(id: '', location_id: '',
      reference_id: '', line_items: line_items, 
      total_amount: total_amount, customer_id: '', order_state: '')*/;
  Subscription_details? subscription_details /*= Subscription_details(id: '', location: '',
      customer: '', subscription_plan: subscription_plan, start_date: '', 
      status: '', invoices: invoices)*/;


  factory All_info_invoice.fromJson(Map<String, dynamic> json) {
    return All_info_invoice(
      invoice_activities: (json['invoice_activities'] as List<dynamic>).map((dynamic e) =>
          Invoice_activity.fromJson(e as Map<String, dynamic>)).toList(),

      order_details: json['order_details'] == null ? null : Order.fromJson(json['order_details']),
      subscription_details: json['subscription_details'] == null ? null : Subscription_details.fromJson(json['subscription_details']),
      //object: json['object'] as Objects,
    );
  }


//<editor-fold desc="Data Methods">

  All_info_invoice({
    required this.invoice_activities,
    required this.order_details,
    required this.subscription_details,
  });

 /* static get line_items => null;

  static get total_amount => null;

  static get subscription_plan => null;

  static get invoices => null;*/



 

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is All_info_invoice &&
          runtimeType == other.runtimeType &&
          invoice_activities == other.invoice_activities &&
          order_details == other.order_details &&
          subscription_details == other.subscription_details);

  @override
  int get hashCode =>
      invoice_activities.hashCode ^
      order_details.hashCode ^
      subscription_details.hashCode;

  @override
  String toString() {
    return 'All_info_invoice{' +
        ' invoice_activities: $invoice_activities,' +
        ' order_details: $order_details,' +
        ' subscription_details: $subscription_details,' +
        '}';
  }

  All_info_invoice copyWith({
    List<Invoice_activity>? invoice_activities,
    Order? order_details,
    Subscription_details? subscription_details,
  }) {
    return All_info_invoice(
      invoice_activities: invoice_activities ?? this.invoice_activities,
      order_details: order_details ?? this.order_details,
      subscription_details: subscription_details ?? this.subscription_details,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoice_activities': this.invoice_activities,
      'order_details': this.order_details,
      'subscription_details': this.subscription_details,
    };
  }

  factory All_info_invoice.fromMap(Map<String, dynamic> map) {
    return All_info_invoice(
      invoice_activities: map['invoice_activities'] as List<Invoice_activity>,
      order_details: map['order_details'] as Order,
      subscription_details: map['subscription_details'] as Subscription_details,
    );
  }

//</editor-fold>
}