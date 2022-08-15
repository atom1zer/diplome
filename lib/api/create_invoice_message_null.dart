class Create_invoice_mess_null{

  String order_id;
  String delivery_method;
  String payment_method;
  String due_date;


  factory Create_invoice_mess_null.fromJson(Map<String, dynamic> json) {
    return Create_invoice_mess_null(
      order_id: json['order_id'] as String,
      delivery_method: json['delivery_method'] as String,
      payment_method: json['payment_method'] as String,
      due_date: json['due_date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'order_id': order_id,
      'delivery_method': delivery_method,
      'payment_method': payment_method,
      'due_date': due_date,
    };
  }


//<editor-fold desc="Data Methods">

  Create_invoice_mess_null({
    required this.order_id,
    required this.delivery_method,
    required this.payment_method,
    required this.due_date,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Create_invoice_mess_null &&
          runtimeType == other.runtimeType &&
          order_id == other.order_id &&
          delivery_method == other.delivery_method &&
          payment_method == other.payment_method &&
          due_date == other.due_date);

  @override
  int get hashCode =>
      order_id.hashCode ^
      delivery_method.hashCode ^
      payment_method.hashCode ^
      due_date.hashCode;

  @override
  String toString() {
    return 'Create_invoice_mess_null{' +
        ' order_id: $order_id,' +
        ' delivery_method: $delivery_method,' +
        ' payment_method: $payment_method,' +
        ' due_date: $due_date,' +
        '}';
  }

  Create_invoice_mess_null copyWith({
    String? order_id,
    String? delivery_method,
    String? payment_method,
    String? due_date,
  }) {
    return Create_invoice_mess_null(
      order_id: order_id ?? this.order_id,
      delivery_method: delivery_method ?? this.delivery_method,
      payment_method: payment_method ?? this.payment_method,
      due_date: due_date ?? this.due_date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_id': this.order_id,
      'delivery_method': this.delivery_method,
      'payment_method': this.payment_method,
      'due_date': this.due_date,
    };
  }

  factory Create_invoice_mess_null.fromMap(Map<String, dynamic> map) {
    return Create_invoice_mess_null(
      order_id: map['order_id'] as String,
      delivery_method: map['delivery_method'] as String,
      payment_method: map['payment_method'] as String,
      due_date: map['due_date'] as String,
    );
  }

//</editor-fold>
}