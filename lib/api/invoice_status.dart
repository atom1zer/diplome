class Invoice_status{
  String id;
  String status;


  factory Invoice_status.fromJson(Map<String, dynamic> json) {
    return Invoice_status(
      id: json['id'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'status': status,
    };
  }


//<editor-fold desc="Data Methods">

  Invoice_status({
    required this.id,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice_status &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status);

  @override
  int get hashCode => id.hashCode ^ status.hashCode;

  @override
  String toString() {
    return 'Invoice_status{' + ' id: $id,' + ' status: $status,' + '}';
  }

  Invoice_status copyWith({
    String? id,
    String? status,
  }) {
    return Invoice_status(
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'status': this.status,
    };
  }

  factory Invoice_status.fromMap(Map<String, dynamic> map) {
    return Invoice_status(
      id: map['id'] as String,
      status: map['status'] as String,
    );
  }

//</editor-fold>
}