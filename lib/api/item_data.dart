import 'package:auth_ui/api/variations.dart';

class Item_data{

  String name;
  List<Variations> variations;
  String label_color;
  String visibility;
  String product_type;
  bool skip_modifier_screen;
  String ecom_visibility;



  factory Item_data.fromJson(Map<String, dynamic> json) {
    return Item_data(
      label_color: json['label_color'] as String,
      visibility: json['visibility'] as String,
      name: json['name'] as String,
      variations:
      (json['variations'] as List<dynamic>).map((dynamic e) => Variations.fromJson(e as Map<String, dynamic>)).toList(),
      product_type: json['product_type'] as String,
      skip_modifier_screen: json['skip_modifier_screen'] as bool,
      ecom_visibility: json['ecom_visibility'] as String,

    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'variations' : variations.map((e) => e.toJson()).toList(),

      'label_color': label_color,
      'visibility' : visibility,
      'product_type': product_type,
      'skip_modifier_screen' : skip_modifier_screen,
      'ecom_visibility': ecom_visibility,


    };
  }

//<editor-fold desc="Data Methods">

  Item_data({
    required this.name,
    required this.variations,
    required this.label_color,
    required this.visibility,
    required this.product_type,
    required this.skip_modifier_screen,
    required this.ecom_visibility,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item_data &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          variations == other.variations &&
          label_color == other.label_color &&
          visibility == other.visibility &&
          product_type == other.product_type &&
          skip_modifier_screen == other.skip_modifier_screen &&
          ecom_visibility == other.ecom_visibility);

  @override
  int get hashCode =>
      name.hashCode ^
      variations.hashCode ^
      label_color.hashCode ^
      visibility.hashCode ^
      product_type.hashCode ^
      skip_modifier_screen.hashCode ^
      ecom_visibility.hashCode;

  @override
  String toString() {
    return 'Item_data{' +
        ' name: $name,' +
        ' variations: $variations,' +
        ' label_color: $label_color,' +
        ' visibility: $visibility,' +
        ' product_type: $product_type,' +
        ' skip_modifier_screen: $skip_modifier_screen,' +
        ' ecom_visibility: $ecom_visibility,' +
        '}';
  }

  Item_data copyWith({
    String? name,
    List<Variations>? variations,
    String? label_color,
    String? visibility,
    String? product_type,
    bool? skip_modifier_screen,
    String? ecom_visibility,
  }) {
    return Item_data(
      name: name ?? this.name,
      variations: variations ?? this.variations,
      label_color: label_color ?? this.label_color,
      visibility: visibility ?? this.visibility,
      product_type: product_type ?? this.product_type,
      skip_modifier_screen: skip_modifier_screen ?? this.skip_modifier_screen,
      ecom_visibility: ecom_visibility ?? this.ecom_visibility,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'variations': this.variations,
      'label_color': this.label_color,
      'visibility': this.visibility,
      'product_type': this.product_type,
      'skip_modifier_screen': this.skip_modifier_screen,
      'ecom_visibility': this.ecom_visibility,
    };
  }

  factory Item_data.fromMap(Map<String, dynamic> map) {
    return Item_data(
      name: map['name'] as String,
      variations: map['variations'] as List<Variations>,
      label_color: map['label_color'] as String,
      visibility: map['visibility'] as String,
      product_type: map['product_type'] as String,
      skip_modifier_screen: map['skip_modifier_screen'] as bool,
      ecom_visibility: map['ecom_visibility'] as String,
    );
  }

//</editor-fold>
}