import 'package:auth_ui/api/parse_for_transactions.dart';
import 'package:auth_ui/api/plot_data.dart';

class In_catalog_reports{

  Plot_data? plot_data;
  List<Parse_for_transacrions>? transactions;
  bool isExpended = false;

  In_catalog_reports({
    this.plot_data,
    this.transactions,
  });

   In_catalog_reports.fromJson(Map<String, dynamic> json) {
      plot_data = Plot_data.fromJson(json['plot_data']);
      transactions = json['transactions'] != null ? (json['transactions'] as List<dynamic>).map((dynamic e) =>
          Parse_for_transacrions.fromJson(e as Map<String, dynamic>)).toList() : null;

  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'plot_data': plot_data,
      'transactions': transactions,
    };
  }


//<editor-fold desc="Data Methods">


/*
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is In_catalog_reports &&
          runtimeType == other.runtimeType &&
          plot_data == other.plot_data &&
          transactions == other.transactions);

  @override
  int get hashCode => plot_data.hashCode ^ transactions.hashCode;

  @override
  String toString() {
    return 'Catalog_reports{' +
        ' plot_data: $plot_data,' +
        ' transactions: $transactions,' +
        '}';
  }

  In_catalog_reports copyWith({
    Plot_data? plot_data,
    List<Parse_for_transacrions>? transactions,
  }) {
    return In_catalog_reports(
      plot_data: plot_data ?? this.plot_data,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plot_data': this.plot_data,
      'transactions': this.transactions,
    };
  }

  factory In_catalog_reports.fromMap(Map<String, dynamic> map) {
    return In_catalog_reports(
      plot_data: map['plot_data'] as Plot_data,
      transactions: map['transactions'] as List<Parse_for_transacrions>,
    );
  }
*/
//</editor-fold>
}