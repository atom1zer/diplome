import 'package:auth_ui/api/order.dart';

class Parse_checkout{

  String id;
  String checkout_page_url;
  String redirect_url;
  String payment_status;
  Order order;
  bool isExpended = false;


  factory Parse_checkout.fromJson(Map<String, dynamic> json) {
    return Parse_checkout(
      id: json['id'] as String,
      checkout_page_url: json['checkout_page_url'] as String,
      redirect_url: json['redirect_url'] as String,
      payment_status: json['payment_status'] as String,
      order: Order.fromJson(json['order']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'checkout_page_url': checkout_page_url,
      'redirect_url': redirect_url,
      'payment_status' : payment_status,
      'order' : order,
    };
  }


//<editor-fold desc="Data Methods">

  Parse_checkout({
    required this.id,
    required this.checkout_page_url,
    required this.redirect_url,
    required this.payment_status,
    required this.order,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Parse_checkout &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          checkout_page_url == other.checkout_page_url &&
          redirect_url == other.redirect_url &&
          payment_status == other.payment_status &&
          order == other.order);

  @override
  int get hashCode =>
      id.hashCode ^
      checkout_page_url.hashCode ^
      redirect_url.hashCode ^
      payment_status.hashCode ^
      order.hashCode;

  @override
  String toString() {
    return 'Parse_checkout{' +
        ' id: $id,' +
        ' checkout_page_url: $checkout_page_url,' +
        ' redirect_url: $redirect_url,' +
        ' payment_status: $payment_status,' +
        ' order: $order,' +
        '}';
  }

  Parse_checkout copyWith({
    String? id,
    String? checkout_page_url,
    String? redirect_url,
    String? payment_status,
    Order? order,
  }) {
    return Parse_checkout(
      id: id ?? this.id,
      checkout_page_url: checkout_page_url ?? this.checkout_page_url,
      redirect_url: redirect_url ?? this.redirect_url,
      payment_status: payment_status ?? this.payment_status,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'checkout_page_url': this.checkout_page_url,
      'redirect_url': this.redirect_url,
      'payment_status': this.payment_status,
      'order': this.order,
    };
  }

  factory Parse_checkout.fromMap(Map<String, dynamic> map) {
    return Parse_checkout(
      id: map['id'] as String,
      checkout_page_url: map['checkout_page_url'] as String,
      redirect_url: map['redirect_url'] as String,
      payment_status: map['payment_status'] as String,
      order: map['order'] as Order,
    );
  }

//</editor-fold>
}