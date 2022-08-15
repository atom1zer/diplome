import 'customers_cc.dart';

class Catalog_cc{

  List<Customers_cc> customers_cc;


  factory Catalog_cc.fromJson(Map<String, dynamic> json) {
    return Catalog_cc(
      customers_cc: (json['data'] as List<dynamic>).map((dynamic e) => Customers_cc.fromJson(e as Map<String, dynamic>)).toList(),
      //object: json['object'] as Objects,
    );
  }


//<editor-fold desc="Data Methods">

  Catalog_cc({
    required this.customers_cc,
  });

  @override

  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Catalog_cc &&
          runtimeType == other.runtimeType &&
          customers_cc == other.customers_cc);

  @override
  int get hashCode => customers_cc.hashCode;

  @override
  String toString() {
    return 'Catalog_cc{' + ' customers_cc: $customers_cc,' + '}';
  }

  Catalog_cc copyWith({
    List<Customers_cc>? customers_cc,
  }) {
    return Catalog_cc(
      customers_cc: customers_cc ?? this.customers_cc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customers_cc': this.customers_cc,
    };
  }

  factory Catalog_cc.fromMap(Map<String, dynamic> map) {
    return Catalog_cc(
      customers_cc: map['customers_cc'] as List<Customers_cc>,
    );
  }

//</editor-fold>
}