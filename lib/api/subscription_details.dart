import 'package:auth_ui/api/sub_plan.dart';

import 'customers_cc.dart';
import 'invoice_in_list.dart';
import 'location.dart';

class Subscription_details{

  String id;
  Location location;
  Customers_cc customer;
  Subscription_plan subscription_plan;
  String start_date;
  String status;
  List<Invoice_in_list> invoices;
  bool isExpended = false;


  factory Subscription_details.fromJson(Map<String, dynamic> json) {
    return Subscription_details(

      id: json['id'] as String,
      location: Location.fromJson(json['location']),
      customer: Customers_cc.fromJson(json['customer']),
      start_date: json['start_date'] as String,
      status: json['status'] as String,
      subscription_plan: Subscription_plan.fromJson(json['subscription_plan']),
      invoices: (json['invoices'] as List<dynamic>).map((dynamic e) => Invoice_in_list.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'location': location,
      'customer': customer,
      'subscription_plan': subscription_plan,
      'start_date': start_date,
      'status': status,
      'invoices': invoices,
    };
  }


//<editor-fold desc="Data Methods">

  Subscription_details({
    required this.id,
    required this.location,
    required this.customer,
    required this.subscription_plan,
    required this.start_date,
    required this.status,
    required this.invoices,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription_details &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          location == other.location &&
          customer == other.customer &&
          subscription_plan == other.subscription_plan &&
          start_date == other.start_date &&
          status == other.status &&
          invoices == other.invoices);

  @override
  int get hashCode =>
      id.hashCode ^
      location.hashCode ^
      customer.hashCode ^
      subscription_plan.hashCode ^
      start_date.hashCode ^
      status.hashCode ^
      invoices.hashCode;

  @override
  String toString() {
    return 'Subscription_details{' +
        ' id: $id,' +
        ' location: $location,' +
        ' customer: $customer,' +
        ' subscription_plan: $subscription_plan,' +
        ' start_date: $start_date,' +
        ' status: $status,' +
        ' invoices: $invoices,' +
        '}';
  }

  Subscription_details copyWith({
    String? id,
    Location? location,
    Customers_cc? customer,
    Subscription_plan? subscription_plan,
    String? start_date,
    String? status,
    List<Invoice_in_list>? invoices,
  }) {
    return Subscription_details(
      id: id ?? this.id,
      location: location ?? this.location,
      customer: customer ?? this.customer,
      subscription_plan: subscription_plan ?? this.subscription_plan,
      start_date: start_date ?? this.start_date,
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'location': this.location,
      'customer': this.customer,
      'subscription_plan': this.subscription_plan,
      'start_date': this.start_date,
      'status': this.status,
      'invoices': this.invoices,
    };
  }

  factory Subscription_details.fromMap(Map<String, dynamic> map) {
    return Subscription_details(
      id: map['id'] as String,
      location: map['location'] as Location,
      customer: map['customer'] as Customers_cc,
      subscription_plan: map['subscription_plan'] as Subscription_plan,
      start_date: map['start_date'] as String,
      status: map['status'] as String,
      invoices: map['invoices'] as List<Invoice_in_list>,
    );
  }

//</editor-fold>
}