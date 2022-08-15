class Bace_price_money{
  int amount;
  String currency;



  factory Bace_price_money.fromJson(Map<String, dynamic> json) {
    return Bace_price_money(
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

  Bace_price_money({
    required this.amount,
    required this.currency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bace_price_money &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          currency == other.currency);

  @override
  int get hashCode => amount.hashCode ^ currency.hashCode;

  @override
  String toString() {
    return 'Bace_price_money{' +
        ' amount: $amount,' +
        ' currency: $currency,' +
        '}';
  }

  Bace_price_money copyWith({
    int? amount,
    String? currency,
  }) {
    return Bace_price_money(
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

  factory Bace_price_money.fromMap(Map<String, dynamic> map) {
    return Bace_price_money(
      amount: map['amount'] as int,
      currency: map['currency'] as String,
    );
  }

//</editor-fold>
}