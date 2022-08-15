class Segment_ids{

  String segment_ids;


  factory Segment_ids.fromJson(Map<String, dynamic> json) {
    return Segment_ids(
      segment_ids: json['segment_ids'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'segment_ids': segment_ids,
    };
  }

//<editor-fold desc="Data Methods">

  Segment_ids({
    required this.segment_ids,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Segment_ids &&
          runtimeType == other.runtimeType &&
          segment_ids == other.segment_ids);

  @override
  int get hashCode => segment_ids.hashCode;

  @override
  String toString() {
    return 'Segment_ids{' + ' segment_ids: $segment_ids,' + '}';
  }

  Segment_ids copyWith({
    String? segment_ids,
  }) {
    return Segment_ids(
      segment_ids: segment_ids ?? this.segment_ids,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'segment_ids': this.segment_ids,
    };
  }

  factory Segment_ids.fromMap(Map<String, dynamic> map) {
    return Segment_ids(
      segment_ids: map['segment_ids'] as String,
    );
  }

//</editor-fold>
}