import 'package:auth_ui/api/recurring_price_money.dart';

class Subscription_plan{
  String id;
  String name;
  String cadence;
  Recurring_price_money recurring_price_money;


  factory Subscription_plan.fromJson(Map<String, dynamic> json) {
    return Subscription_plan(
      id: json['id'] as String,
      name: json['name'] as String,
      cadence: json['cadence'] as String,
      recurring_price_money: Recurring_price_money.fromJson(json['recurring_price_money']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'cadence': cadence,
      'recurring_price_money': recurring_price_money,
    };
  }


//<editor-fold desc="Data Methods">

  Subscription_plan({
    required this.id,
    required this.name,
    required this.cadence,
    required this.recurring_price_money,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription_plan &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          cadence == other.cadence &&
          recurring_price_money == other.recurring_price_money);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      cadence.hashCode ^
      recurring_price_money.hashCode;

  @override
  String toString() {
    return 'Subscription_plan{' +
        ' id: $id,' +
        ' name: $name,' +
        ' cadence: $cadence,' +
        ' recurring_price_money: $recurring_price_money,' +
        '}';
  }

  Subscription_plan copyWith({
    String? id,
    String? name,
    String? cadence,
    Recurring_price_money? recurring_price_money,
  }) {
    return Subscription_plan(
      id: id ?? this.id,
      name: name ?? this.name,
      cadence: cadence ?? this.cadence,
      recurring_price_money:
          recurring_price_money ?? this.recurring_price_money,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'cadence': this.cadence,
      'recurring_price_money': this.recurring_price_money,
    };
  }

  factory Subscription_plan.fromMap(Map<String, dynamic> map) {
    return Subscription_plan(
      id: map['id'] as String,
      name: map['name'] as String,
      cadence: map['cadence'] as String,
      recurring_price_money:
          map['recurring_price_money'] as Recurring_price_money,
    );
  }

//</editor-fold>
}