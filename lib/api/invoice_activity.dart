class Invoice_activity{

  String invoice_id;
  String activity_type;
  String date;

  factory Invoice_activity.fromJson(Map<String, dynamic> json) {
    return Invoice_activity(
      invoice_id: json['invoice_id'] as String,
      activity_type: json['activity_type'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'invoice_id': invoice_id,
      'activity_type': activity_type,
      'date': date,
    };
  }

//<editor-fold desc="Data Methods">

  Invoice_activity({
    required this.invoice_id,
    required this.activity_type,
    required this.date,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice_activity &&
          runtimeType == other.runtimeType &&
          invoice_id == other.invoice_id &&
          activity_type == other.activity_type &&
          date == other.date);

  @override
  int get hashCode =>
      invoice_id.hashCode ^ activity_type.hashCode ^ date.hashCode;

  @override
  String toString() {
    return 'Invoice_activity{' +
        ' invoice_id: $invoice_id,' +
        ' activity_type: $activity_type,' +
        ' date: $date,' +
        '}';
  }

  Invoice_activity copyWith({
    String? invoice_id,
    String? activity_type,
    String? date,
  }) {
    return Invoice_activity(
      invoice_id: invoice_id ?? this.invoice_id,
      activity_type: activity_type ?? this.activity_type,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoice_id': this.invoice_id,
      'activity_type': this.activity_type,
      'date': this.date,
    };
  }

  factory Invoice_activity.fromMap(Map<String, dynamic> map) {
    return Invoice_activity(
      invoice_id: map['invoice_id'] as String,
      activity_type: map['activity_type'] as String,
      date: map['date'] as String,
    );
  }

//</editor-fold>
}