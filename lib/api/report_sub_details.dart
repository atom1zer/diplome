class Report_sub_datails{

  String? plan_name;


  Report_sub_datails({
    this.plan_name,
  });

   Report_sub_datails.fromJson(Map<String, dynamic> json) {
     plan_name = json['plan_name'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'plan_name': plan_name,
    };
  }


//<editor-fold desc="Data Methods">

  /*

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Report_sub_datails &&
          runtimeType == other.runtimeType &&
          plan_name == other.plan_name);

  @override
  int get hashCode => plan_name.hashCode;

  @override
  String toString() {
    return 'Report_sub_datails{' + ' plan_name: $plan_name,' + '}';
  }

  Report_sub_datails copyWith({
    String? plan_name,
  }) {
    return Report_sub_datails(
      plan_name: plan_name ?? this.plan_name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plan_name': this.plan_name,
    };
  }

  factory Report_sub_datails.fromMap(Map<String, dynamic> map) {
    return Report_sub_datails(
      plan_name: map['plan_name'] as String,
    );
  }
*/
//</editor-fold>
}