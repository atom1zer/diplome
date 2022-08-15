import 'include_order.dart';

class Parse_order{
  Include_order order;


  factory Parse_order.fromJson(Map<String, dynamic> json) {
    return Parse_order(
      order: Include_order.fromJson(json['order']),

    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'order': order,

    };
  }


//<editor-fold desc="Data Methods">

  Parse_order({
    required this.order,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Parse_order &&
          runtimeType == other.runtimeType &&
          order == other.order);

  @override
  int get hashCode => order.hashCode;

  @override
  String toString() {
    return 'Parse_order{' + ' order: $order,' + '}';
  }

  Parse_order copyWith({
    Include_order? order,
  }) {
    return Parse_order(
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': this.order,
    };
  }

  factory Parse_order.fromMap(Map<String, dynamic> map) {
    return Parse_order(
      order: map['order'] as Include_order,
    );
  }

//</editor-fold>
}