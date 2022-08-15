import 'location.dart';

class Locations_catalog{

  List<Location> locations_catalog;


  factory Locations_catalog.fromJson(Map<String, dynamic> json) {
    return Locations_catalog(
      locations_catalog: (json['data'] as List<dynamic>).map((dynamic e) => Location.fromJson(e as Map<String, dynamic>)).toList(),
      //object: json['object'] as Objects,
    );
  }


//<editor-fold desc="Data Methods">

  Locations_catalog({
    required this.locations_catalog,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Locations_catalog &&
          runtimeType == other.runtimeType &&
          locations_catalog == other.locations_catalog);

  @override
  int get hashCode => locations_catalog.hashCode;

  @override
  String toString() {
    return 'Locations_catalog{' +
        ' locations_catalog: $locations_catalog,' +
        '}';
  }

  Locations_catalog copyWith({
    List<Location>? locations_catalog,
  }) {
    return Locations_catalog(
      locations_catalog: locations_catalog ?? this.locations_catalog,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locations_catalog': this.locations_catalog,
    };
  }

  factory Locations_catalog.fromMap(Map<String, dynamic> map) {
    return Locations_catalog(
      locations_catalog: map['locations_catalog'] as List<Location>,
    );
  }

//</editor-fold>
}