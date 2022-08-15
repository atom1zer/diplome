class Adres_Customer {


  String address_line_1;
  String address_line_2;
  String locality;
  String administrative_district_level_1;
  String postal_code;
  String country;


  factory Adres_Customer.fromJson(Map<String, dynamic> json) {
    return Adres_Customer(
      address_line_1: json['address_line_1'] as String,
      address_line_2: json['address_line_2'] as String,
      locality: json['locality'] as String,
      administrative_district_level_1: json['administrative_district_level_1'] as String,
      postal_code: json['postal_code'] as String,
      country: json['country'] as String,

    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'address_line_1': address_line_1,
      'address_line_2': address_line_2,
      'locality' : locality,
      'administrative_district_level_1': administrative_district_level_1,
      'postal_code' : postal_code,
      'country': country,

    };
  }


//<editor-fold desc="Data Methods">

  Adres_Customer({
    required this.address_line_1,
    required this.address_line_2,
    required this.locality,
    required this.administrative_district_level_1,
    required this.postal_code,
    required this.country,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Adres_Customer &&
          runtimeType == other.runtimeType &&
          address_line_1 == other.address_line_1 &&
          address_line_2 == other.address_line_2 &&
          locality == other.locality &&
          administrative_district_level_1 ==
              other.administrative_district_level_1 &&
          postal_code == other.postal_code &&
          country == other.country);

  @override
  int get hashCode =>
      address_line_1.hashCode ^
      address_line_2.hashCode ^
      locality.hashCode ^
      administrative_district_level_1.hashCode ^
      postal_code.hashCode ^
      country.hashCode;

  @override
  String toString() {
    return 'Adres_Customer{' +
        ' address_line_1: $address_line_1,' +
        ' address_line_2: $address_line_2,' +
        ' locality: $locality,' +
        ' administrative_district_level_1: $administrative_district_level_1,' +
        ' postal_code: $postal_code,' +
        ' country: $country,' +
        '}';
  }

  Adres_Customer copyWith({
    String? address_line_1,
    String? address_line_2,
    String? locality,
    String? administrative_district_level_1,
    String? postal_code,
    String? country,
  }) {
    return Adres_Customer(
      address_line_1: address_line_1 ?? this.address_line_1,
      address_line_2: address_line_2 ?? this.address_line_2,
      locality: locality ?? this.locality,
      administrative_district_level_1: administrative_district_level_1 ??
          this.administrative_district_level_1,
      postal_code: postal_code ?? this.postal_code,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address_line_1': this.address_line_1,
      'address_line_2': this.address_line_2,
      'locality': this.locality,
      'administrative_district_level_1': this.administrative_district_level_1,
      'postal_code': this.postal_code,
      'country': this.country,
    };
  }

  factory Adres_Customer.fromMap(Map<String, dynamic> map) {
    return Adres_Customer(
      address_line_1: map['address_line_1'] as String,
      address_line_2: map['address_line_2'] as String,
      locality: map['locality'] as String,
      administrative_district_level_1:
          map['administrative_district_level_1'] as String,
      postal_code: map['postal_code'] as String,
      country: map['country'] as String,
    );
  }

//</editor-fold>
}