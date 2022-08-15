import 'base_price_money.dart';

class Line_include{
  String quantity;
  String name;
  Bace_price_money bace_price_money;



  factory Line_include.fromJson(Map<String, dynamic> json) {
    return Line_include(
      quantity: json['quantity'] as String,
      name: json['name'] as String,
      bace_price_money: Bace_price_money.fromJson(json['base_price_money']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'quantity': quantity,
      'name': name,
      'base_price_money' : bace_price_money,
    };
  }

//<editor-fold desc="Data Methods">

  Line_include({
    required this.quantity,
    required this.name,
    required this.bace_price_money,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Line_include &&
          runtimeType == other.runtimeType &&
          quantity == other.quantity &&
          name == other.name &&
          bace_price_money == other.bace_price_money);

  @override
  int get hashCode =>
      quantity.hashCode ^ name.hashCode ^ bace_price_money.hashCode;

  @override
  String toString() {
    return 'Line_include{' +
        ' quantity: $quantity,' +
        ' name: $name,' +
        ' bace_price_money: $bace_price_money,' +
        '}';
  }

  Line_include copyWith({
    String? quantity,
    String? name,
    Bace_price_money? bace_price_money,
  }) {
    return Line_include(
      quantity: quantity ?? this.quantity,
      name: name ?? this.name,
      bace_price_money: bace_price_money ?? this.bace_price_money,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': this.quantity,
      'name': this.name,
      'bace_price_money': this.bace_price_money,
    };
  }

  factory Line_include.fromMap(Map<String, dynamic> map) {
    return Line_include(
      quantity: map['quantity'] as String,
      name: map['name'] as String,
      bace_price_money: map['bace_price_money'] as Bace_price_money,
    );
  }

//</editor-fold>
}