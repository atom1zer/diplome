class Model_var{
  String name;
  String descriptions;
  String currency = 'USD';

//<editor-fold desc="Data Methods">

  Model_var({
    required this.name,
    required this.descriptions,
    required this.currency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Model_var &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          descriptions == other.descriptions &&
          currency == other.currency);

  @override
  int get hashCode => name.hashCode ^ descriptions.hashCode ^ currency.hashCode;

  @override
  String toString() {
    return 'Model_var{' +
        ' name: $name,' +
        ' descriptions: $descriptions,' +
        ' currency: $currency,' +
        '}';
  }

  Model_var copyWith({
    String? name,
    String? descriptions,
    String? currency,
  }) {
    return Model_var(
      name: name ?? this.name,
      descriptions: descriptions ?? this.descriptions,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'descriptions': this.descriptions,
      'currency': this.currency,
    };
  }

  factory Model_var.fromMap(Map<String, dynamic> map) {
    return Model_var(
      name: map['name'] as String,
      descriptions: map['descriptions'] as String,
      currency: map['currency'] as String,
    );
  }

//</editor-fold>
}