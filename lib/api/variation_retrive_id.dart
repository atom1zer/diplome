import 'package:auth_ui/api/variation_add_table.dart';
import 'package:auth_ui/api/variations.dart';

class Variation_retrive_id{
  Variation_add_table object;


  factory Variation_retrive_id.fromJson(Map<String, dynamic> json) {
    return Variation_retrive_id(
      object: Variation_add_table.fromJson(json['object']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'object': object,

    };
  }

//<editor-fold desc="Data Methods">

  Variation_retrive_id({
    required this.object,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Variation_retrive_id &&
          runtimeType == other.runtimeType &&
          object == other.object);

  @override
  int get hashCode => object.hashCode;

  @override
  String toString() {
    return 'Variation_retrive_id{' + ' object: $object,' + '}';
  }

  Variation_retrive_id copyWith({
    Variation_add_table? object,
  }) {
    return Variation_retrive_id(
      object: object ?? this.object,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'object': this.object,
    };
  }

  factory Variation_retrive_id.fromMap(Map<String, dynamic> map) {
    return Variation_retrive_id(
      object: map['object'] as Variation_add_table,
    );
  }

//</editor-fold>
}