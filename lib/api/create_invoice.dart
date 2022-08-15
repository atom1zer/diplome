class Create_invoice{

  String order_id;
  String delivery_method;
  String payment_method;
  String due_date;
  String? message;


  factory Create_invoice.fromJson(Map<String, dynamic> json) {
    return Create_invoice(
      order_id: json['order_id'] as String,
      delivery_method: json['delivery_method'] as String,
      payment_method: json['payment_method'] as String,
      due_date: json['due_date'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'order_id': order_id,
      'delivery_method': delivery_method,
      'payment_method': payment_method,
      'due_date': due_date,
      'message': message
    };
  }


//<editor-fold desc="Data Methods">

  Create_invoice({
    required this.order_id,
    required this.delivery_method,
    required this.payment_method,
    required this.due_date,
    required this.message,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Create_invoice &&
          runtimeType == other.runtimeType &&
          order_id == other.order_id &&
          delivery_method == other.delivery_method &&
          payment_method == other.payment_method &&
          due_date == other.due_date &&
          message == other.message);

  @override
  int get hashCode =>
      order_id.hashCode ^
      delivery_method.hashCode ^
      payment_method.hashCode ^
      due_date.hashCode ^
      message.hashCode;

  @override
  String toString() {
    return 'Create_invoice{' +
        ' order_id: $order_id,' +
        ' delivery_method: $delivery_method,' +
        ' payment_method: $payment_method,' +
        ' due_date: $due_date,' +
        ' message: $message,' +
        '}';
  }

  Create_invoice copyWith({
    String? order_id,
    String? delivery_method,
    String? payment_method,
    String? due_date,
    String? message,
  }) {
    return Create_invoice(
      order_id: order_id ?? this.order_id,
      delivery_method: delivery_method ?? this.delivery_method,
      payment_method: payment_method ?? this.payment_method,
      due_date: due_date ?? this.due_date,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_id': this.order_id,
      'delivery_method': this.delivery_method,
      'payment_method': this.payment_method,
      'due_date': this.due_date,
      'message': this.message,
    };
  }

  factory Create_invoice.fromMap(Map<String, dynamic> map) {
    return Create_invoice(
      order_id: map['order_id'] as String,
      delivery_method: map['delivery_method'] as String,
      payment_method: map['payment_method'] as String,
      due_date: map['due_date'] as String,
      message: map['message'] as String,
    );
  }

//</editor-fold>
}