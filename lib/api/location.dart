class Location{

  String id;
  String name;


  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }


//<editor-fold desc="Data Methods">

  Location({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'Location{' + ' id: $id,' + ' name: $name,' + '}';
  }

  Location copyWith({
    String? id,
    String? name,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

//</editor-fold>
}