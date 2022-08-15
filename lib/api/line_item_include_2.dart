class Line_item_include_2{
  String quantity;
  String catalog_object_id;


  factory Line_item_include_2.fromJson(Map<String, dynamic> json) {
    return Line_item_include_2(
      quantity: json['quantity'] as String,
      catalog_object_id: json['catalog_object_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'quantity': quantity,
      'catalog_object_id': catalog_object_id,
    };
  }


//<editor-fold desc="Data Methods">

  Line_item_include_2({
    required this.quantity,
    required this.catalog_object_id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Line_item_include_2 &&
          runtimeType == other.runtimeType &&
          quantity == other.quantity &&
          catalog_object_id == other.catalog_object_id);

  @override
  int get hashCode => quantity.hashCode ^ catalog_object_id.hashCode;

  @override
  String toString() {
    return 'Line_item_include_2{' +
        ' quantity: $quantity,' +
        ' catalog_object_id: $catalog_object_id,' +
        '}';
  }

  Line_item_include_2 copyWith({
    String? quantity,
    String? catalog_object_id,
  }) {
    return Line_item_include_2(
      quantity: quantity ?? this.quantity,
      catalog_object_id: catalog_object_id ?? this.catalog_object_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': this.quantity,
      'catalog_object_id': this.catalog_object_id,
    };
  }

  factory Line_item_include_2.fromMap(Map<String, dynamic> map) {
    return Line_item_include_2(
      quantity: map['quantity'] as String,
      catalog_object_id: map['catalog_object_id'] as String,
    );
  }

//</editor-fold>
}