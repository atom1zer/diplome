class Recurring_price_money{
  int amount;
  String currency;


  factory Recurring_price_money.fromJson(Map<String, dynamic> json) {
    return Recurring_price_money(
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

  Recurring_price_money({
    required this.amount,
    required this.currency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recurring_price_money &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          currency == other.currency);

  @override
  int get hashCode => amount.hashCode ^ currency.hashCode;

  @override
  String toString() {
    return 'Recurring_price_money{' +
        ' amount: $amount,' +
        ' currency: $currency,' +
        '}';
  }

  Recurring_price_money copyWith({
    int? amount,
    String? currency,
  }) {
    return Recurring_price_money(
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

  factory Recurring_price_money.fromMap(Map<String, dynamic> map) {
    return Recurring_price_money(
      amount: map['amount'] as int,
      currency: map['currency'] as String,
    );
  }

//</editor-fold>
}