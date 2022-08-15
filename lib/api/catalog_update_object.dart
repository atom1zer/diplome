
import 'add_object.dart';


class Catalog_retrive {
  Add_Objects add_object;


  factory Catalog_retrive.fromJson(Map<String, dynamic> json) {
    return Catalog_retrive(
      add_object: Add_Objects.fromJson(json['object'] ),
      //object: json['object'] as Objects,
    );
  }

//<editor-fold desc="Data Methods">

  Catalog_retrive({
    required this.add_object,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Catalog_retrive &&
          runtimeType == other.runtimeType &&
          add_object == other.add_object);

  @override
  int get hashCode => add_object.hashCode;

  @override
  String toString() {
    return 'Catalog_retrive{' + ' add_object: $add_object,' + '}';
  }

  Catalog_retrive copyWith({
    Add_Objects? add_object,
  }) {
    return Catalog_retrive(
      add_object: add_object ?? this.add_object,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'add_object': this.add_object,
    };
  }

  factory Catalog_retrive.fromMap(Map<String, dynamic> map) {
    return Catalog_retrive(
      add_object: map['add_object'] as Add_Objects,
    );
  }

//</editor-fold>
}