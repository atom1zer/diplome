import 'package:auth_ui/api/subscription_details.dart';

class Catalog_subscriptions{

  List<Subscription_details> catalog_subscriptions;


  factory Catalog_subscriptions.fromJson(Map<String, dynamic> json) {
    return Catalog_subscriptions(
      catalog_subscriptions: (json['data'] as List<dynamic>).map((dynamic e) =>
          Subscription_details.fromJson(e as Map<String, dynamic>)).toList(),
      //object: json['object'] as Objects,
    );
  }


//<editor-fold desc="Data Methods">

  Catalog_subscriptions({
    required this.catalog_subscriptions,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Catalog_subscriptions &&
          runtimeType == other.runtimeType &&
          catalog_subscriptions == other.catalog_subscriptions);

  @override
  int get hashCode => catalog_subscriptions.hashCode;

  @override
  String toString() {
    return 'Catalog_subscriptions{' +
        ' catalog_subscriptions: $catalog_subscriptions,' +
        '}';
  }

  Catalog_subscriptions copyWith({
    List<Subscription_details>? catalog_subscriptions,
  }) {
    return Catalog_subscriptions(
      catalog_subscriptions:
          catalog_subscriptions ?? this.catalog_subscriptions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'catalog_subscriptions': this.catalog_subscriptions,
    };
  }

  factory Catalog_subscriptions.fromMap(Map<String, dynamic> map) {
    return Catalog_subscriptions(
      catalog_subscriptions:
          map['catalog_subscriptions'] as List<Subscription_details>,
    );
  }

//</editor-fold>
}