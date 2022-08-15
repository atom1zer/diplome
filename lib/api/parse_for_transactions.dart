import 'package:auth_ui/api/parse_line_items_for_reports.dart';
import 'package:auth_ui/api/report_sub_details.dart';


class Parse_for_transacrions{

  List<Parse_line_items_for_reports>? line_items;
  String? customer_email;
  int? total_amount;
  String? location_name;
  String? transaction_type;
  Report_sub_datails? subscription_delails;
  bool Expanded = false;


  Parse_for_transacrions({
    this.line_items,
    this.customer_email,
    this.total_amount,
    this.location_name,
    this.transaction_type,
    this.subscription_delails,
  });


   Parse_for_transacrions.fromJson(Map<String, dynamic> json) {
      line_items =  json['line_items'] != null ? (json['line_items'] as List<dynamic>).map((dynamic e) =>
          Parse_line_items_for_reports.fromJson(e as Map<String, dynamic>)).toList() : null;
      customer_email =  json['customer_email'] as String;
      total_amount = json['total_amount'] as int;
      location_name =  json['location_name'] as String;
      transaction_type =  json['transaction_type'] as String;
      subscription_delails = json['subscription_details'] != null ? Report_sub_datails.fromJson(json['subscription_details']) : null;

  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'line_items': line_items,
      'customer_email': customer_email,
      'total_amount': total_amount,
      'location_name': location_name,
      'transaction_type': transaction_type,
      'subscription_delails': subscription_delails,
    };
  }


//<editor-fold desc="Data Methods">



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Parse_for_transacrions &&
          runtimeType == other.runtimeType &&
          line_items == other.line_items &&
          customer_email == other.customer_email &&
          total_amount == other.total_amount &&
          location_name == other.location_name &&
          transaction_type == other.transaction_type &&
          subscription_delails == other.subscription_delails);

  @override
  int get hashCode =>
      line_items.hashCode ^
      customer_email.hashCode ^
      total_amount.hashCode ^
      location_name.hashCode ^
      transaction_type.hashCode ^
      subscription_delails.hashCode;

  @override
  String toString() {
    return 'Parse_for_transacrions{' +
        ' line_items: $line_items,' +
        ' customer_email: $customer_email,' +
        ' total_amount: $total_amount,' +
        ' location_name: $location_name,' +
        ' transaction_type: $transaction_type,' +
        ' subscription_delails: $subscription_delails,' +
        '}';
  }

  Parse_for_transacrions copyWith({
    List<Parse_line_items_for_reports>? line_items,
    String? customer_email,
    int? total_amount,
    String? location_name,
    String? transaction_type,
    Report_sub_datails? subscription_delails,
    bool? isExpended,
  }) {
    return Parse_for_transacrions(
      line_items: line_items ?? this.line_items,
      customer_email: customer_email ?? this.customer_email,
      total_amount: total_amount ?? this.total_amount,
      location_name: location_name ?? this.location_name,
      transaction_type: transaction_type ?? this.transaction_type,
      subscription_delails: subscription_delails ?? this.subscription_delails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'line_items': this.line_items,
      'customer_email': this.customer_email,
      'total_amount': this.total_amount,
      'location_name': this.location_name,
      'transaction_type': this.transaction_type,
      'subscription_delails': this.subscription_delails,
    };
  }

  factory Parse_for_transacrions.fromMap(Map<String, dynamic> map) {
    return Parse_for_transacrions(
      line_items: map['line_items'] as List<Parse_line_items_for_reports>,
      customer_email: map['customer_email'] as String,
      total_amount: map['total_amount'] as int,
      location_name: map['location_name'] as String,
      transaction_type: map['transaction_type'] as String,
      subscription_delails: map['subscription_delails'] as Report_sub_datails,
    );
  }

//</editor-fold>
}