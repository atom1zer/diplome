class Top_item{

  String name;
  int quantity;


  factory Top_item.fromJson(Map<String, dynamic> json) {
    return Top_item(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
    };
  }


//<editor-fold desc="Data Methods">

  Top_item({
    required this.name,
    required this.quantity,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Top_item &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          quantity == other.quantity);

  @override
  int get hashCode => name.hashCode ^ quantity.hashCode;

  @override
  String toString() {
    return 'Top_item{' + ' name: $name,' + ' quantity: $quantity,' + '}';
  }

  Top_item copyWith({
    String? name,
    int? quantity,
  }) {
    return Top_item(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'quantity': this.quantity,
    };
  }

  factory Top_item.fromMap(Map<String, dynamic> map) {
    return Top_item(
      name: map['name'] as String,
      quantity: map['quantity'] as int,
    );
  }

//</editor-fold>
}