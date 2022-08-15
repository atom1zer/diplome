import 'package:auth_ui/api/sub_plan.dart';

class Add_sub_plan{

  String idempotency_key;
  Subscription_plan subscription_plan;


  factory Add_sub_plan.fromJson(Map<String, dynamic> json) {
    return Add_sub_plan(
      idempotency_key: json['idempotency_key'] as String,
      subscription_plan: Subscription_plan.fromJson(json['subscription_plan']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'idempotency_key': idempotency_key,
      'subscription_plan': subscription_plan,
    };
  }


//<editor-fold desc="Data Methods">

  Add_sub_plan({
    required this.idempotency_key,
    required this.subscription_plan,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Add_sub_plan &&
          runtimeType == other.runtimeType &&
          idempotency_key == other.idempotency_key &&
          subscription_plan == other.subscription_plan);

  @override
  int get hashCode => idempotency_key.hashCode ^ subscription_plan.hashCode;

  @override
  String toString() {
    return 'Add_sub_plan{' +
        ' idempotency_key: $idempotency_key,' +
        ' subscription_plan: $subscription_plan,' +
        '}';
  }

  Add_sub_plan copyWith({
    String? idempotency_key,
    Subscription_plan? subscription_plan,
  }) {
    return Add_sub_plan(
      idempotency_key: idempotency_key ?? this.idempotency_key,
      subscription_plan: subscription_plan ?? this.subscription_plan,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idempotency_key': this.idempotency_key,
      'subscription_plan': this.subscription_plan,
    };
  }

  factory Add_sub_plan.fromMap(Map<String, dynamic> map) {
    return Add_sub_plan(
      idempotency_key: map['idempotency_key'] as String,
      subscription_plan: map['subscription_plan'] as Subscription_plan,
    );
  }

//</editor-fold>
}