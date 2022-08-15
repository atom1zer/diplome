class Order_total_amount{

  int amount;
  String currency;


  factory Order_total_amount.fromJson(Map<String, dynamic> json) {
    return Order_total_amount(
      amount: json['amount'] as int,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'currency': currency,
    };
  }


//<editor-fold desc="Data Methods">

  Order_total_amount({
    required this.amount,
    required this.currency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order_total_amount &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          currency == other.currency);

  @override
  int get hashCode => amount.hashCode ^ currency.hashCode;

  @override
  String toString() {
    return 'Order_total_amount{' +
        ' amount: $amount,' +
        ' currency: $currency,' +
        '}';
  }

  Order_total_amount copyWith({
    int? amount,
    String? currency,
  }) {
    return Order_total_amount(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': this.amount,
      'currency': this.currency,
    };
  }

  factory Order_total_amount.fromMap(Map<String, dynamic> map) {
    return Order_total_amount(
      amount: map['amount'] as int,
      currency: map['currency'] as String,
    );
  }

//</editor-fold>
}