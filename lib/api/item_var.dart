import 'package:auth_ui/api/price_money.dart';


class Item_var{
  String name;
  Price_money price_money;
  String pricing_type;
  String item_id;
  int ordinal;
  bool sellable;
  bool stockable;



  factory Item_var.fromJson(Map<String, dynamic> json) {
    return Item_var(
      name: json['name'] as String,
      price_money: Price_money.fromJson(json['price_money']),
      pricing_type: json['pricing_type'] as String,
      item_id: json['item_id'] as String,
      ordinal: json['ordinal'] as int,
      sellable: json['sellable'] as bool,
      stockable: json['stockable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'price_money': price_money,
      'pricing_type': pricing_type,
      'item_id': item_id,
      'ordinal': ordinal,
      'sellable': sellable,
      'stockable': stockable,

    };
  }

//<editor-fold desc="Data Methods">

  Item_var({
    required this.name,
    required this.price_money,
    required this.pricing_type,
    required this.item_id,
    required this.ordinal,
    required this.sellable,
    required this.stockable,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item_var &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price_money == other.price_money &&
          pricing_type == other.pricing_type &&
          item_id == other.item_id &&
          ordinal == other.ordinal &&
          sellable == other.sellable &&
          stockable == other.stockable);

  @override
  int get hashCode =>
      name.hashCode ^
      price_money.hashCode ^
      pricing_type.hashCode ^
      item_id.hashCode ^
      ordinal.hashCode ^
      sellable.hashCode ^
      stockable.hashCode;

  @override
  String toString() {
    return 'Item_var{' +
        ' name: $name,' +
        ' price_money: $price_money,' +
        ' pricing_type: $pricing_type,' +
        ' item_id: $item_id,' +
        ' ordinal: $ordinal,' +
        ' sellable: $sellable,' +
        ' stockable: $stockable,' +
        '}';
  }

  Item_var copyWith({
    String? name,
    Price_money? price_money,
    String? pricing_type,
    String? item_id,
    int? ordinal,
    bool? sellable,
    bool? stockable,
  }) {
    return Item_var(
      name: name ?? this.name,
      price_money: price_money ?? this.price_money,
      pricing_type: pricing_type ?? this.pricing_type,
      item_id: item_id ?? this.item_id,
      ordinal: ordinal ?? this.ordinal,
      sellable: sellable ?? this.sellable,
      stockable: stockable ?? this.stockable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'price_money': this.price_money,
      'pricing_type': this.pricing_type,
      'item_id': this.item_id,
      'ordinal': this.ordinal,
      'sellable': this.sellable,
      'stockable': this.stockable,
    };
  }

  factory Item_var.fromMap(Map<String, dynamic> map) {
    return Item_var(
      name: map['name'] as String,
      price_money: map['price_money'] as Price_money,
      pricing_type: map['pricing_type'] as String,
      item_id: map['item_id'] as String,
      ordinal: map['ordinal'] as int,
      sellable: map['sellable'] as bool,
      stockable: map['stockable'] as bool,
    );
  }

//</editor-fold>
}