class Add_sub{

  String idempotency_key;
  String location_id;
  String plan_id;
  String customer_id;
  String start_date;


  factory Add_sub.fromJson(Map<String, dynamic> json) {
    return Add_sub(
      idempotency_key: json['idempotency_key'] as String,
      location_id: json['location_id'] as String,
      plan_id: json['plan_id'] as String,
      customer_id: json['customer_id'] as String,
      start_date: json['start_date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'idempotency_key': idempotency_key,
      'location_id': location_id,
      'plan_id': plan_id,
      'customer_id': customer_id,
      'start_date': start_date,
    };
  }


//<editor-fold desc="Data Methods">

  Add_sub({
    required this.idempotency_key,
    required this.location_id,
    required this.plan_id,
    required this.customer_id,
    required this.start_date,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Add_sub &&
          runtimeType == other.runtimeType &&
          idempotency_key == other.idempotency_key &&
          location_id == other.location_id &&
          plan_id == other.plan_id &&
          customer_id == other.customer_id &&
          start_date == other.start_date);

  @override
  int get hashCode =>
      idempotency_key.hashCode ^
      location_id.hashCode ^
      plan_id.hashCode ^
      customer_id.hashCode ^
      start_date.hashCode;

  @override
  String toString() {
    return 'Add_sub{' +
        ' idempotency_key: $idempotency_key,' +
        ' location_id: $location_id,' +
        ' plan_id: $plan_id,' +
        ' customer_id: $customer_id,' +
        ' start_date: $start_date,' +
        '}';
  }

  Add_sub copyWith({
    String? idempotency_key,
    String? location_id,
    String? plan_id,
    String? customer_id,
    String? start_date,
  }) {
    return Add_sub(
      idempotency_key: idempotency_key ?? this.idempotency_key,
      location_id: location_id ?? this.location_id,
      plan_id: plan_id ?? this.plan_id,
      customer_id: customer_id ?? this.customer_id,
      start_date: start_date ?? this.start_date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idempotency_key': this.idempotency_key,
      'location_id': this.location_id,
      'plan_id': this.plan_id,
      'customer_id': this.customer_id,
      'start_date': this.start_date,
    };
  }

  factory Add_sub.fromMap(Map<String, dynamic> map) {
    return Add_sub(
      idempotency_key: map['idempotency_key'] as String,
      location_id: map['location_id'] as String,
      plan_id: map['plan_id'] as String,
      customer_id: map['customer_id'] as String,
      start_date: map['start_date'] as String,
    );
  }

//</editor-fold>
}