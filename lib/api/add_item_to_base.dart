import 'package:auth_ui/api/add_object.dart';

class Add_Catalog{
  String idempotency_key;
  Add_Objects add_object;


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'idempotency_key' : idempotency_key,
      'object': add_object
    };
  }

//<editor-fold desc="Data Methods">

  Add_Catalog({
    required this.idempotency_key,
    required this.add_object,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Add_Catalog &&
          runtimeType == other.runtimeType &&
          idempotency_key == other.idempotency_key &&
          add_object == other.add_object);

  @override
  int get hashCode => idempotency_key.hashCode ^ add_object.hashCode;

  @override
  String toString() {
    return 'Catalog{' +
        ' idempotency_key: $idempotency_key,' +
        ' add_object: $add_object,' +
        '}';
  }

  Add_Catalog copyWith({
    String? idempotency_key,
    Add_Objects? add_object,
  }) {
    return Add_Catalog(
      idempotency_key: idempotency_key ?? this.idempotency_key,
      add_object: add_object ?? this.add_object,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idempotency_key': this.idempotency_key,
      'add_object': this.add_object,
    };
  }

  factory Add_Catalog.fromMap(Map<String, dynamic> map) {
    return Add_Catalog(
      idempotency_key: map['idempotency_key'] as String,
      add_object: map['add_object'] as Add_Objects,
    );
  }

//</editor-fold>
}