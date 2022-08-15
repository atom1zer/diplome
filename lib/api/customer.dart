import 'customers_cc.dart';

class Customer{
  Customers_cc customer;


  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customer:  Customers_cc.fromJson(json['customer']),
    );
  }

//<editor-fold desc="Data Methods">

  Customer({
    required this.customer,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          runtimeType == other.runtimeType &&
          customer == other.customer);

  @override
  int get hashCode => customer.hashCode;

  @override
  String toString() {
    return 'Customer{' + ' customer: $customer,' + '}';
  }

  Customer copyWith({
    Customers_cc? customer,
  }) {
    return Customer(
      customer: customer ?? this.customer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customer': this.customer,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      customer: map['customer'] as Customers_cc,
    );
  }

//</editor-fold>
}