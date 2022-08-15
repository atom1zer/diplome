import 'item_var.dart';

class Variations{
  String id;
  String type;
  Item_var item_variation_data;
  String updated_at;
  String created_at;
  String version;
  bool is_deleted;
  bool present_at_all_locations;


  factory Variations.fromJson(Map<String, dynamic> json) {
    return Variations(
      id: json['id'] as String,
      type: json['type'] as String,
      item_variation_data: Item_var.fromJson(json['item_variation_data']),
      updated_at: json['updated_at'] as String,
      created_at: json['created_at'] as String,
      version: json['version'] as String,
      is_deleted: json['is_deleted'] as bool,
      present_at_all_locations: json['present_at_all_locations'] as bool,

    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'item_variation_data': item_variation_data,
      'updated_at': updated_at,
      'created_at': created_at,
      'version': version,
      'is_deleted': is_deleted,
      'present_at_all_locations': present_at_all_locations,


    };
  }

//<editor-fold desc="Data Methods">

  Variations({
    required this.id,
    required this.type,
    required this.item_variation_data,
    required this.updated_at,
    required this.created_at,
    required this.version,
    required this.is_deleted,
    required this.present_at_all_locations,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Variations &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          item_variation_data == other.item_variation_data &&
          updated_at == other.updated_at &&
          created_at == other.created_at &&
          version == other.version &&
          is_deleted == other.is_deleted &&
          present_at_all_locations == other.present_at_all_locations);

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      item_variation_data.hashCode ^
      updated_at.hashCode ^
      created_at.hashCode ^
      version.hashCode ^
      is_deleted.hashCode ^
      present_at_all_locations.hashCode;

  @override
  String toString() {
    return 'Variations{' +
        ' id: $id,' +
        ' type: $type,' +
        ' item_variation_data: $item_variation_data,' +
        ' updated_at: $updated_at,' +
        ' created_at: $created_at,' +
        ' version: $version,' +
        ' is_deleted: $is_deleted,' +
        ' present_at_all_locations: $present_at_all_locations,' +
        '}';
  }

  Variations copyWith({
    String? id,
    String? type,
    Item_var? item_variation_data,
    String? updated_at,
    String? created_at,
    String? version,
    bool? is_deleted,
    bool? present_at_all_locations,
  }) {
    return Variations(
      id: id ?? this.id,
      type: type ?? this.type,
      item_variation_data: item_variation_data ?? this.item_variation_data,
      updated_at: updated_at ?? this.updated_at,
      created_at: created_at ?? this.created_at,
      version: version ?? this.version,
      is_deleted: is_deleted ?? this.is_deleted,
      present_at_all_locations:
          present_at_all_locations ?? this.present_at_all_locations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'type': this.type,
      'item_variation_data': this.item_variation_data,
      'updated_at': this.updated_at,
      'created_at': this.created_at,
      'version': this.version,
      'is_deleted': this.is_deleted,
      'present_at_all_locations': this.present_at_all_locations,
    };
  }

  factory Variations.fromMap(Map<String, dynamic> map) {
    return Variations(
      id: map['id'] as String,
      type: map['type'] as String,
      item_variation_data: map['item_variation_data'] as Item_var,
      updated_at: map['updated_at'] as String,
      created_at: map['created_at'] as String,
      version: map['version'] as String,
      is_deleted: map['is_deleted'] as bool,
      present_at_all_locations: map['present_at_all_locations'] as bool,
    );
  }

//</editor-fold>
}