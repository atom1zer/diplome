import 'package:auth_ui/api/sub_plan.dart';

class Catalog_plan{

  List<Subscription_plan> catalog_plan;


  factory Catalog_plan.fromJson(Map<String, dynamic> json) {
    return Catalog_plan(
      catalog_plan: (json['data'] as List<dynamic>).map((dynamic e) => Subscription_plan.fromJson(e as Map<String, dynamic>)).toList(),
      //object: json['object'] as Objects,
    );
  }



//<editor-fold desc="Data Methods">

  Catalog_plan({
    required this.catalog_plan,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Catalog_plan &&
          runtimeType == other.runtimeType &&
          catalog_plan == other.catalog_plan);

  @override
  int get hashCode => catalog_plan.hashCode;

  @override
  String toString() {
    return 'Catalog_plan{' + ' catalog_plan: $catalog_plan,' + '}';
  }

  Catalog_plan copyWith({
    List<Subscription_plan>? catalog_plan,
  }) {
    return Catalog_plan(
      catalog_plan: catalog_plan ?? this.catalog_plan,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'catalog_plan': this.catalog_plan,
    };
  }

  factory Catalog_plan.fromMap(Map<String, dynamic> map) {
    return Catalog_plan(
      catalog_plan: map['catalog_plan'] as List<Subscription_plan>,
    );
  }

//</editor-fold>
}