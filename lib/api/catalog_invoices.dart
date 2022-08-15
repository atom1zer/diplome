import 'package:auth_ui/api/invoice_in_list.dart';

class Catalog_invoices{
  List<Invoice_in_list> catalog_invoices;


  factory Catalog_invoices.fromJson(Map<String, dynamic> json) {
    return Catalog_invoices(
      catalog_invoices: (json['data'] as List<dynamic>).map((dynamic e) => Invoice_in_list.fromJson(e as Map<String, dynamic>)).toList(),
      //object: json['object'] as Objects,
    );
  }


//<editor-fold desc="Data Methods">

  Catalog_invoices({
    required this.catalog_invoices,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Catalog_invoices &&
          runtimeType == other.runtimeType &&
          catalog_invoices == other.catalog_invoices);

  @override
  int get hashCode => catalog_invoices.hashCode;

  @override
  String toString() {
    return 'Catalog_invoices{' + ' catalog_invoices: $catalog_invoices,' + '}';
  }

  Catalog_invoices copyWith({
    List<Invoice_in_list>? catalog_invoices,
  }) {
    return Catalog_invoices(
      catalog_invoices: catalog_invoices ?? this.catalog_invoices,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'catalog_invoices': this.catalog_invoices,
    };
  }

  factory Catalog_invoices.fromMap(Map<String, dynamic> map) {
    return Catalog_invoices(
      catalog_invoices: map['catalog_invoices'] as List<Invoice_in_list>,
    );
  }

//</editor-fold>
}