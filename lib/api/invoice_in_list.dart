class Invoice_in_list{
  String id;
  String location_id;
  String order_id;
  String subscription_id;
  String status;
  String due_date;
  String payment_method;
  String delivery_method;
  int amount_money;
  String pay_invoice_url;
  String message;


  factory Invoice_in_list.fromJson(Map<String, dynamic> json) {
    return Invoice_in_list(
      id: json['id'] as String,
      location_id: json['location_id'] as String,
      order_id: json['order_id'] as String,
      subscription_id: json['subscription_id'] as String,
      status: json['status'] as String,
      due_date: json['due_date'] as String,
      payment_method: json['payment_method'] as String,
      delivery_method: json['delivery_method'] as String,
      amount_money: json['amount_money'] as int,
      pay_invoice_url: json['pay_invoice_url'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'location_id': location_id,
      'order_id': order_id,
      'subscription_id': subscription_id,
      'status': status,
      'due_date': due_date,
      'payment_method': payment_method,
      'delivery_method': delivery_method,
      'amount_money': amount_money,
      'pay_invoice_url': pay_invoice_url,
      'message': message,
    };
  }

//<editor-fold desc="Data Methods">

  Invoice_in_list({
    required this.id,
    required this.location_id,
    required this.order_id,
    required this.subscription_id,
    required this.status,
    required this.due_date,
    required this.payment_method,
    required this.delivery_method,
    required this.amount_money,
    required this.pay_invoice_url,
    required this.message,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice_in_list &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          location_id == other.location_id &&
          order_id == other.order_id &&
          subscription_id == other.subscription_id &&
          status == other.status &&
          due_date == other.due_date &&
          payment_method == other.payment_method &&
          delivery_method == other.delivery_method &&
          amount_money == other.amount_money &&
          pay_invoice_url == other.pay_invoice_url &&
          message == other.message);

  @override
  int get hashCode =>
      id.hashCode ^
      location_id.hashCode ^
      order_id.hashCode ^
      subscription_id.hashCode ^
      status.hashCode ^
      due_date.hashCode ^
      payment_method.hashCode ^
      delivery_method.hashCode ^
      amount_money.hashCode ^
      pay_invoice_url.hashCode ^
      message.hashCode;

  @override
  String toString() {
    return 'Invoice_in_list{' +
        ' id: $id,' +
        ' location_id: $location_id,' +
        ' order_id: $order_id,' +
        ' subscription_id: $subscription_id,' +
        ' status: $status,' +
        ' due_date: $due_date,' +
        ' payment_method: $payment_method,' +
        ' delivery_method: $delivery_method,' +
        ' amount_money: $amount_money,' +
        ' pay_invoice_url: $pay_invoice_url,' +
        ' message: $message,' +
        '}';
  }

  Invoice_in_list copyWith({
    String? id,
    String? location_id,
    String? order_id,
    String? subscription_id,
    String? status,
    String? due_date,
    String? payment_method,
    String? delivery_method,
    int? amount_money,
    String? pay_invoice_url,
    String? message,
  }) {
    return Invoice_in_list(
      id: id ?? this.id,
      location_id: location_id ?? this.location_id,
      order_id: order_id ?? this.order_id,
      subscription_id: subscription_id ?? this.subscription_id,
      status: status ?? this.status,
      due_date: due_date ?? this.due_date,
      payment_method: payment_method ?? this.payment_method,
      delivery_method: delivery_method ?? this.delivery_method,
      amount_money: amount_money ?? this.amount_money,
      pay_invoice_url: pay_invoice_url ?? this.pay_invoice_url,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'location_id': this.location_id,
      'order_id': this.order_id,
      'subscription_id': this.subscription_id,
      'status': this.status,
      'due_date': this.due_date,
      'payment_method': this.payment_method,
      'delivery_method': this.delivery_method,
      'amount_money': this.amount_money,
      'pay_invoice_url': this.pay_invoice_url,
      'message': this.message,
    };
  }

  factory Invoice_in_list.fromMap(Map<String, dynamic> map) {
    return Invoice_in_list(
      id: map['id'] as String,
      location_id: map['location_id'] as String,
      order_id: map['order_id'] as String,
      subscription_id: map['subscription_id'] as String,
      status: map['status'] as String,
      due_date: map['due_date'] as String,
      payment_method: map['payment_method'] as String,
      delivery_method: map['delivery_method'] as String,
      amount_money: map['amount_money'] as int,
      pay_invoice_url: map['pay_invoice_url'] as String,
      message: map['message'] as String,
    );
  }

//</editor-fold>
}