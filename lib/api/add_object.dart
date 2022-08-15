import 'add_item_data.dart';

class Add_Objects {
  String id;
  String type;
  Add_Item_data add_item_data;


  factory Add_Objects.fromJson(Map<String, dynamic> json) {
    return Add_Objects(
      id: json['id'] as String,
      type: json['type'] as String,
      add_item_data: Add_Item_data.fromJson(json['item_data']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'item_data': add_item_data

    };
  }

//<editor-fold desc="Data Methods">

  Add_Objects({
    required this.id,
    required this.type,
    required this.add_item_data,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Add_Objects &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          add_item_data == other.add_item_data);

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ add_item_data.hashCode;

  @override
  String toString() {
    return 'Add_Objects{' +
        ' id: $id,' +
        ' type: $type,' +
        ' add_item_data: $add_item_data,' +
        '}';
  }

  Add_Objects copyWith({
    String? id,
    String? type,
    Add_Item_data? add_item_data,
  }) {
    return Add_Objects(
      id: id ?? this.id,
      type: type ?? this.type,
      add_item_data: add_item_data ?? this.add_item_data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'type': this.type,
      'add_item_data': this.add_item_data,
    };
  }

  factory Add_Objects.fromMap(Map<String, dynamic> map) {
    return Add_Objects(
      id: map['id'] as String,
      type: map['type'] as String,
      add_item_data: map['add_item_data'] as Add_Item_data,
    );
  }

//</editor-fold>
}