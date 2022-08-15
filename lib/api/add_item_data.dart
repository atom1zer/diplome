import 'add_variations.dart';

class Add_Item_data {
  String description;
  String name;
  List<Add_Variations> add_variations;

//<editor-fold desc="Data Methods">

  Add_Item_data({
    required this.description,
    required this.name,
    required this.add_variations,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Add_Item_data &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          name == other.name &&
          add_variations == other.add_variations);

  @override
  int get hashCode =>
      description.hashCode ^
      name.hashCode ^
      add_variations.hashCode;

  @override
  String toString() {
    return 'Add_Item_data{' +
        ' description: $description,' +
        ' name: $name,' +
        ' add_variations: $add_variations,' +
        '}';
  }

  Add_Item_data copyWith({
    String? abbreviation,
    String? description,
    String? name,
    List<Add_Variations>? add_variations,
  }) {
    return Add_Item_data(
      description: description ?? this.description,
      name: name ?? this.name,
      add_variations: add_variations ?? this.add_variations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': this.description,
      'name': this.name,
      'add_variations': this.add_variations,
    };
  }

  factory Add_Item_data.fromMap(Map<String, dynamic> map) {
    return Add_Item_data(
      description: map['description'] as String,
      name: map['name'] as String,
      add_variations: map['add_variations'] as List<Add_Variations>,
    );
  }

//</editor-fold>

  factory Add_Item_data.fromJson(Map<String, dynamic> json) {
    return Add_Item_data(
      description: json['description'] as String,
      name: json['name'] as String,
      add_variations:
      (json['variations'] as List<dynamic>).map((dynamic e) => Add_Variations.fromJson(e as Map<String, dynamic>)).toList(),

    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'description': description,
      'name': name,
      'variations' : add_variations.map((e) => e.toJson()).toList()

    };
  }

}