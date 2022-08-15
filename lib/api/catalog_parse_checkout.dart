import 'package:auth_ui/api/parse_checkout.dart';

class Catalog_parse_checkout{

  List<Parse_checkout> catalog_checkout;


  factory Catalog_parse_checkout.fromJson(Map<String, dynamic> json) {
    return Catalog_parse_checkout(
      catalog_checkout: (json['data'] as List<dynamic>).map((dynamic e) => Parse_checkout.fromJson(e as Map<String, dynamic>)).toList(),
      //object: json['object'] as Objects,
    );
  }


//<editor-fold desc="Data Methods">

  Catalog_parse_checkout({
    required this.catalog_checkout,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Catalog_parse_checkout &&
          runtimeType == other.runtimeType &&
          catalog_checkout == other.catalog_checkout);

  @override
  int get hashCode => catalog_checkout.hashCode;

  @override
  String toString() {
    return 'Catalog_parse_checkout{' +
        ' catalog_checkout: $catalog_checkout,' +
        '}';
  }

  Catalog_parse_checkout copyWith({
    List<Parse_checkout>? catalog_checkout,
  }) {
    return Catalog_parse_checkout(
      catalog_checkout: catalog_checkout ?? this.catalog_checkout,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'catalog_checkout': this.catalog_checkout,
    };
  }

  factory Catalog_parse_checkout.fromMap(Map<String, dynamic> map) {
    return Catalog_parse_checkout(
      catalog_checkout: map['catalog_checkout'] as List<Parse_checkout>,
    );
  }

//</editor-fold>
}