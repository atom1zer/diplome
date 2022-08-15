class Sum_of{

  int checkouts;
  int order_invoices;
  int subscription_invoices;


  factory Sum_of.fromJson(Map<String, dynamic> json) {
    return Sum_of(
      checkouts: json['checkouts'] as int,
      order_invoices: json['order_invoices'] as int,
      subscription_invoices: json['subscription_invoices'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'checkouts': checkouts,
      'order_invoices': order_invoices,
      'subscription_invoices': subscription_invoices,
    };
  }


//<editor-fold desc="Data Methods">

  Sum_of({
    required this.checkouts,
    required this.order_invoices,
    required this.subscription_invoices,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sum_of &&
          runtimeType == other.runtimeType &&
          checkouts == other.checkouts &&
          order_invoices == other.order_invoices &&
          subscription_invoices == other.subscription_invoices);

  @override
  int get hashCode =>
      checkouts.hashCode ^
      order_invoices.hashCode ^
      subscription_invoices.hashCode;

  @override
  String toString() {
    return 'Sum_of{' +
        ' checkouts: $checkouts,' +
        ' order_invoices: $order_invoices,' +
        ' subscription_invoices: $subscription_invoices,' +
        '}';
  }

  Sum_of copyWith({
    int? checkouts,
    int? order_invoices,
    int? subscription_invoices,
  }) {
    return Sum_of(
      checkouts: checkouts ?? this.checkouts,
      order_invoices: order_invoices ?? this.order_invoices,
      subscription_invoices:
          subscription_invoices ?? this.subscription_invoices,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'checkouts': this.checkouts,
      'order_invoices': this.order_invoices,
      'subscription_invoices': this.subscription_invoices,
    };
  }

  factory Sum_of.fromMap(Map<String, dynamic> map) {
    return Sum_of(
      checkouts: map['checkouts'] as int,
      order_invoices: map['order_invoices'] as int,
      subscription_invoices: map['subscription_invoices'] as int,
    );
  }

//</editor-fold>
}