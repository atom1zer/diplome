import 'package:auth_ui/api/price_money.dart';

class Add_Item_Var{
  String name;
  Price_money price_money;
  String pricing_type;
  String item_id;


  factory Add_Item_Var.fromJson(Map<String, dynamic> json) {
    return Add_Item_Var(
      name: json['name'] as String,
      price_money: Price_money.fromJson(json['price_money']),
      pricing_type: json['pricing_type'] as String,
      item_id: json['item_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'price_money': price_money,
      'pricing_type': pricing_type,
      'item_id': item_id

    };
  }

//<editor-fold desc="Data Methods">

  Add_Item_Var({
    required this.name,
    required this.price_money,
    required this.pricing_type,
    required this.item_id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Add_Item_Var &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price_money == other.price_money &&
          pricing_type == other.pricing_type &&
          item_id == other.item_id);

  @override
  int get hashCode =>
      name.hashCode ^
      price_money.hashCode ^
      pricing_type.hashCode ^
      item_id.hashCode;

  @override
  String toString() {
    return 'Add_Item_Var{' +
        ' name: $name,' +
        ' price_money: $price_money,' +
        ' pricing_type: $pricing_type,' +
        ' item_id: $item_id,' +
        '}';
  }

  Add_Item_Var copyWith({
    String? name,
    Price_money? price_money,
    String? pricing_type,
    String? item_id,
  }) {
    return Add_Item_Var(
      name: name ?? this.name,
      price_money: price_money ?? this.price_money,
      pricing_type: pricing_type ?? this.pricing_type,
      item_id: item_id ?? this.item_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'price_money': this.price_money,
      'pricing_type': this.pricing_type,
      'item_id': this.item_id,
    };
  }

  factory Add_Item_Var.fromMap(Map<String, dynamic> map) {
    return Add_Item_Var(
      name: map['name'] as String,
      price_money: map['price_money'] as Price_money,
      pricing_type: map['pricing_type'] as String,
      item_id: map['item_id'] as String,
    );
  }

//</editor-fold>
}