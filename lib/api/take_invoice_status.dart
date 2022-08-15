import 'package:auth_ui/api/invoice_status.dart';

class Take_invoice_status{
  Invoice_status invoice;


  factory Take_invoice_status.fromJson(Map<String, dynamic> json) {
    return Take_invoice_status(
      invoice: Invoice_status.fromJson(json['invoice']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{

      'invoice': invoice,
    };
  }

//<editor-fold desc="Data Methods">

  Take_invoice_status({
    required this.invoice,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Take_invoice_status &&
          runtimeType == other.runtimeType &&
          invoice == other.invoice);

  @override
  int get hashCode => invoice.hashCode;

  @override
  String toString() {
    return 'Take_invoice_status{' + ' invoice: $invoice,' + '}';
  }

  Take_invoice_status copyWith({
    Invoice_status? invoice,
  }) {
    return Take_invoice_status(
      invoice: invoice ?? this.invoice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoice': this.invoice,
    };
  }

  factory Take_invoice_status.fromMap(Map<String, dynamic> map) {
    return Take_invoice_status(
      invoice: map['invoice'] as Invoice_status,
    );
  }

//</editor-fold>
}