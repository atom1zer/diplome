class Frecuency{

  String name;
  String value;

//<editor-fold desc="Data Methods">

  Frecuency({
    required this.name,
    required this.value,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Frecuency &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value);

  @override
  int get hashCode => name.hashCode ^ value.hashCode;

  @override
  String toString() {
    return 'Frecuency{' + ' name: $name,' + ' value: $value,' + '}';
  }

  Frecuency copyWith({
    String? name,
    String? value,
  }) {
    return Frecuency(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'value': this.value,
    };
  }

  factory Frecuency.fromMap(Map<String, dynamic> map) {
    return Frecuency(
      name: map['name'] as String,
      value: map['value'] as String,
    );
  }

//</editor-fold>
}