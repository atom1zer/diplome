import 'package:auth_ui/api/sum_of.dart';
import 'package:auth_ui/api/top_item.dart';

class Welcome_stat{

  int full_sum;
  int transactions_count;
  Sum_of sum_of;
  List<Top_item> top_items;

  factory Welcome_stat.fromJson(Map<String, dynamic> json) {
    return Welcome_stat(
      full_sum: json['full_sum'] as int,
      transactions_count: json['transactions_count'] as int,
      sum_of: Sum_of.fromJson(json['sum_of']),
      top_items: (json['top_items'] as List<dynamic>).map((dynamic e) =>
          Top_item.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'full_sum': full_sum,
      'transactions_count': transactions_count,
      'sum_of': sum_of,
      'top_items': top_items,
    };
  }




//<editor-fold desc="Data Methods">

  Welcome_stat({
    required this.full_sum,
    required this.transactions_count,
    required this.sum_of,
    required this.top_items,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Welcome_stat &&
          runtimeType == other.runtimeType &&
          full_sum == other.full_sum &&
          transactions_count == other.transactions_count &&
          sum_of == other.sum_of &&
          top_items == other.top_items);

  @override
  int get hashCode =>
      full_sum.hashCode ^
      transactions_count.hashCode ^
      sum_of.hashCode ^
      top_items.hashCode;

  @override
  String toString() {
    return 'Welcome_stat{' +
        ' full_sum: $full_sum,' +
        ' transactions_count: $transactions_count,' +
        ' sum_of: $sum_of,' +
        ' top_items: $top_items,' +
        '}';
  }

  Welcome_stat copyWith({
    int? full_sum,
    int? transactions_count,
    Sum_of? sum_of,
    List<Top_item>? top_items,
  }) {
    return Welcome_stat(
      full_sum: full_sum ?? this.full_sum,
      transactions_count: transactions_count ?? this.transactions_count,
      sum_of: sum_of ?? this.sum_of,
      top_items: top_items ?? this.top_items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_sum': this.full_sum,
      'transactions_count': this.transactions_count,
      'sum_of': this.sum_of,
      'top_items': this.top_items,
    };
  }

  factory Welcome_stat.fromMap(Map<String, dynamic> map) {
    return Welcome_stat(
      full_sum: map['full_sum'] as int,
      transactions_count: map['transactions_count'] as int,
      sum_of: map['sum_of'] as Sum_of,
      top_items: map['top_items'] as List<Top_item>,
    );
  }

//</editor-fold>
}