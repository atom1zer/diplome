import 'checkout_page_url.dart';

class Take_checkout_page_url{

  Checkout_page_url checkout;


  factory Take_checkout_page_url.fromJson(Map<String, dynamic> json) {
    return Take_checkout_page_url(
      checkout: Checkout_page_url.fromJson(json['checkout']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{

      'checkout': checkout,
    };
  }



//<editor-fold desc="Data Methods">

  Take_checkout_page_url({
    required this.checkout,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Take_checkout_page_url &&
          runtimeType == other.runtimeType &&
          checkout == other.checkout);

  @override
  int get hashCode => checkout.hashCode;

  @override
  String toString() {
    return 'Take_checkout_page_url{' + ' checkout: $checkout,' + '}';
  }

  Take_checkout_page_url copyWith({
    Checkout_page_url? checkout,
  }) {
    return Take_checkout_page_url(
      checkout: checkout ?? this.checkout,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'checkout': this.checkout,
    };
  }

  factory Take_checkout_page_url.fromMap(Map<String, dynamic> map) {
    return Take_checkout_page_url(
      checkout: map['checkout'] as Checkout_page_url,
    );
  }

//</editor-fold>
}