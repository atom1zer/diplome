class Plot_data{

   int? number;
   int? total;

   Plot_data({
      this.number,
      this.total,
   });


  /* factory Plot_data.fromJson(Map<String, dynamic> json) {
     return Plot_data(
       number: json[0] as int,
       total: json[1] as int,
     );
  }*/
    Plot_data.fromJson(Map<String, dynamic> map) {
       number = map['number'];
       total = map['total'];

   }
  }


//<editor-fold desc="Data Methods">


/*
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plot_data &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          total == other.total);

  @override
  int get hashCode => number.hashCode ^ total.hashCode;

  @override
  String toString() {
    return 'Plot_data{' + ' number: $number,' + ' total: $total,' + '}';
  }

  Plot_data copyWith({
    int? number,
    int? total,
  }) {
    return Plot_data(
      number: number ?? this.number,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': this.number,
      'total': this.total,
    };
  }

  factory Plot_data.fromMap(Map<String, dynamic> map) {
    return Plot_data(
      number: map['number'] as int,
      total: map['total'] as int,
    );
  }

//</editor-fold>
*/

