class Parse_line_items_for_reports{

  String? name;
  String? quantity;
  int? amount;


  Parse_line_items_for_reports({
     this.name,
     this.quantity,
     this.amount,
  });


   Parse_line_items_for_reports.fromJson(Map<String, dynamic> json) {
      name = json['name'];
      quantity = json['quantity'];
      amount = json['amount'];

  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
      'amount': amount,

    };
  }


//<editor-fold desc="Data Methods">



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Parse_line_items_for_reports &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          quantity == other.quantity &&
          amount == other.amount);

  @override
  int get hashCode => name.hashCode ^ quantity.hashCode ^ amount.hashCode;

  @override
  String toString() {
    return 'Parse_line_items_for_reports{' +
        ' name: $name,' +
        ' quantity: $quantity,' +
        ' amount: $amount,' +
        '}';
  }

  Parse_line_items_for_reports copyWith({
    String? name,
    String? quantity,
    int? amount,
  }) {
    return Parse_line_items_for_reports(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'quantity': this.quantity,
      'amount': this.amount,
    };
  }

  factory Parse_line_items_for_reports.fromMap(Map<String, dynamic> map) {
    return Parse_line_items_for_reports(
      name: map['name'] as String,
      quantity: map['quantity'] as String,
      amount: map['amount'] as int,
    );
  }

//</editor-fold>
}