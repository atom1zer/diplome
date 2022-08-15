class Include_order{
  String id;

  factory Include_order.fromJson(Map<String, dynamic> json) {
    return Include_order(
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
    };
  }

//<editor-fold desc="Data Methods">

  Include_order({
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Include_order &&
          runtimeType == other.runtimeType &&
          id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Include_order{' + ' id: $id,' + '}';
  }

  Include_order copyWith({
    String? id,
  }) {
    return Include_order(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
    };
  }

  factory Include_order.fromMap(Map<String, dynamic> map) {
    return Include_order(
      id: map['id'] as String,
    );
  }

//</editor-fold>
}