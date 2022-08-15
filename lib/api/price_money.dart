class Price_money{
  int amount;
  String currency;

//<editor-fold desc="Data Methods">

  Price_money({
    required this.amount,
    required this.currency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Price_money &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          currency == other.currency);

  @override
  int get hashCode => amount.hashCode ^ currency.hashCode;

  @override
  String toString() {
    return 'Price_money{' + ' amount: $amount,' + ' currency: $currency,' + '}';
  }

  Price_money copyWith({
    int? amount,
    String? currency,
  }) {
    return Price_money(
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

  /*factory Price_money.fromMap(Map<String, dynamic> map) {
    return Price_money(
      amount: map['amount'] as int,
      currency: map['currency'] as String,
    );
  }*/

//</editor-fold>

  factory Price_money.fromJson(Map<String, dynamic> json) {
    return Price_money(
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

}