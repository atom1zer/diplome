import 'line_include.dart';
import 'line_item_include_2.dart';

class Line_item_in_list{
  Line_include line_include;
  Line_item_include_2 line_item_include_2;


  factory Line_item_in_list.fromJson(Map<String, dynamic> json) {
    return Line_item_in_list(
      line_include: Line_include.fromJson(json['']),
      line_item_include_2: Line_item_include_2.fromJson(json['']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '': line_include,
      '': line_item_include_2,
    };
  }


//<editor-fold desc="Data Methods">

  Line_item_in_list({
    required this.line_include,
    required this.line_item_include_2,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Line_item_in_list &&
          runtimeType == other.runtimeType &&
          line_include == other.line_include &&
          line_item_include_2 == other.line_item_include_2);

  @override
  int get hashCode => line_include.hashCode ^ line_item_include_2.hashCode;

  @override
  String toString() {
    return 'Line_item_in_list{' +
        ' line_include: $line_include,' +
        ' line_item_include_2: $line_item_include_2,' +
        '}';
  }

  Line_item_in_list copyWith({
    Line_include? line_include,
    Line_item_include_2? line_item_include_2,
  }) {
    return Line_item_in_list(
      line_include: line_include ?? this.line_include,
      line_item_include_2: line_item_include_2 ?? this.line_item_include_2,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'line_include': this.line_include,
      'line_item_include_2': this.line_item_include_2,
    };
  }

  factory Line_item_in_list.fromMap(Map<String, dynamic> map) {
    return Line_item_in_list(
      line_include: map['line_include'] as Line_include,
      line_item_include_2: map['line_item_include_2'] as Line_item_include_2,
    );
  }

//</editor-fold>
}