import 'add_item_var.dart';
import 'item_var.dart';

class Add_Variations {
  String id;
  String type;
  Add_Item_Var item_variation_data;



  factory Add_Variations.fromJson(Map<String, dynamic> json) {
    return Add_Variations(
      id: json['id'] as String,
      type: json['type'] as String,
      item_variation_data:  Add_Item_Var.fromJson(json['item_variation_data']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'item_variation_data': item_variation_data

    };
  }

//<editor-fold desc="Data Methods">

  Add_Variations({
    required this.id,
    required this.type,
    required this.item_variation_data,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Add_Variations &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          item_variation_data == other.item_variation_data);

  @override
  int get hashCode =>
      id.hashCode ^ type.hashCode ^ item_variation_data.hashCode;

  @override
  String toString() {
    return 'Add_Variations{' +
        ' id: $id,' +
        ' type: $type,' +
        ' item_variation_data: $item_variation_data,' +
        '}';
  }

  Add_Variations copyWith({
    String? id,
    String? type,
    Add_Item_Var? item_variation_data,
  }) {
    return Add_Variations(
      id: id ?? this.id,
      type: type ?? this.type,
      item_variation_data: item_variation_data ?? this.item_variation_data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'type': this.type,
      'item_variation_data': this.item_variation_data,
    };
  }

  factory Add_Variations.fromMap(Map<String, dynamic> map) {
    return Add_Variations(
      id: map['id'] as String,
      type: map['type'] as String,
      item_variation_data: map['item_variation_data'] as Add_Item_Var,
    );
  }

//</editor-fold>
}
