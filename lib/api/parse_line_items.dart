import 'base_price_money.dart';

class Parse_line_items{

  String quantity;
  String name;
  String catalog_object_id;
  Bace_price_money bace_price_money;


  factory Parse_line_items.fromJson(Map<String, dynamic> json) {
    return Parse_line_items(
      quantity: json['quantity'] as String,
      name: json['name'] as String,
      catalog_object_id: json['catalog_object_id'] as String,
      bace_price_money: Bace_price_money.fromJson(json['base_price_money']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'quantity': quantity,
      'name': name,
      'catalog_object_id': catalog_object_id,
      'base_price_money': bace_price_money,
    };
  }


//<editor-fold desc="Data Methods">

  Parse_line_items({
    required this.quantity,
    required this.name,
    required this.catalog_object_id,
    required this.bace_price_money,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Parse_line_items &&
          runtimeType == other.runtimeType &&
          quantity == other.quantity &&
          name == other.name &&
          catalog_object_id == other.catalog_object_id &&
          bace_price_money == other.bace_price_money);

  @override
  int get hashCode =>
      quantity.hashCode ^
      name.hashCode ^
      catalog_object_id.hashCode ^
      bace_price_money.hashCode;

  @override
  String toString() {
    return 'Parse_line_items{' +
        ' quantity: $quantity,' +
        ' name: $name,' +
        ' catalog_object_id: $catalog_object_id,' +
        ' bace_price_money: $bace_price_money,' +
        '}';
  }

  Parse_line_items copyWith({
    String? quantity,
    String? name,
    String? catalog_object_id,
    Bace_price_money? bace_price_money,
  }) {
    return Parse_line_items(
      quantity: quantity ?? this.quantity,
      name: name ?? this.name,
      catalog_object_id: catalog_object_id ?? this.catalog_object_id,
      bace_price_money: bace_price_money ?? this.bace_price_money,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': this.quantity,
      'name': this.name,
      'catalog_object_id': this.catalog_object_id,
      'bace_price_money': this.bace_price_money,
    };
  }

  factory Parse_line_items.fromMap(Map<String, dynamic> map) {
    return Parse_line_items(
      quantity: map['quantity'] as String,
      name: map['name'] as String,
      catalog_object_id: map['catalog_object_id'] as String,
      bace_price_money: map['bace_price_money'] as Bace_price_money,
    );
  }

//</editor-fold>
}