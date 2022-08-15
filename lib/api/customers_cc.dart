import 'package:auth_ui/api/preferences_cc.dart';

class Customers_cc{

  String id;
  String created_at;
  String updated_at;
  String first_name;
  String second_name;
  String last_name;
  String email_address;
  String phone_number;
  String reference_id;
  String company_name;
  String creation_source;
  String version;


  factory Customers_cc.fromJson(Map<String, dynamic> json) {
    var segment_idsJson = json['segment_ids'];
    List<String>? segment_ids = segment_idsJson != null ? new List.from(segment_idsJson) : null;
    return Customers_cc(
      id: json['id'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
      first_name: json['first_name'] as String,
      second_name: json['second_name'] as String,
      last_name: json['last_name'] as String,
      email_address: json['email_address'] as String,
      phone_number: json['phone_number'] as String,
      company_name: json['company_name'] as String,
      reference_id: json['reference_id'] as String,
      creation_source: json['creation_source'] as String,
      version: json['version'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'created_at': created_at,
      'updated_at' : updated_at,
      'first_name': first_name,
      'second_name' : second_name,
      'last_name' : last_name,
      'email_address': email_address,
      'phone_number': phone_number,
      'company_name': company_name,
      'reference_id': reference_id,
      'version': version,
    };
  }


//<editor-fold desc="Data Methods">

  Customers_cc({
    required this.id,
    required this.created_at,
    required this.updated_at,
    required this.first_name,
    required this.second_name,
    required this.last_name,
    required this.email_address,
    required this.phone_number,
    required this.reference_id,
    required this.company_name,
    required this.creation_source,
    required this.version,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customers_cc &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          created_at == other.created_at &&
          updated_at == other.updated_at &&
          first_name == other.first_name &&
          second_name == other.second_name &&
          last_name == other.last_name &&
          email_address == other.email_address &&
          phone_number == other.phone_number &&
          reference_id == other.reference_id &&
          company_name == other.company_name &&
          creation_source == other.creation_source &&
          version == other.version);

  @override
  int get hashCode =>
      id.hashCode ^
      created_at.hashCode ^
      updated_at.hashCode ^
      first_name.hashCode ^
      second_name.hashCode ^
      last_name.hashCode ^
      email_address.hashCode ^
      phone_number.hashCode ^
      reference_id.hashCode ^
      company_name.hashCode ^
      creation_source.hashCode ^
      version.hashCode;

  @override
  String toString() {
    return 'Customers_cc{' +
        ' id: $id,' +
        ' created_at: $created_at,' +
        ' updated_at: $updated_at,' +
        ' first_name: $first_name,' +
        ' second_name: $second_name,' +
        ' last_name: $last_name,' +
        ' email_address: $email_address,' +
        ' phone_number: $phone_number,' +
        ' reference_id: $reference_id,' +
        ' company_name: $company_name,' +
        ' creation_source: $creation_source,' +
        ' version: $version,' +
        '}';
  }

  Customers_cc copyWith({
    String? id,
    String? created_at,
    String? updated_at,
    String? first_name,
    String? second_name,
    String? last_name,
    String? email_address,
    String? phone_number,
    String? reference_id,
    String? company_name,
    String? creation_source,
    String? version,
  }) {
    return Customers_cc(
      id: id ?? this.id,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      first_name: first_name ?? this.first_name,
      second_name: second_name ?? this.second_name,
      last_name: last_name ?? this.last_name,
      email_address: email_address ?? this.email_address,
      phone_number: phone_number ?? this.phone_number,
      reference_id: reference_id ?? this.reference_id,
      company_name: company_name ?? this.company_name,
      creation_source: creation_source ?? this.creation_source,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'created_at': this.created_at,
      'updated_at': this.updated_at,
      'first_name': this.first_name,
      'second_name': this.second_name,
      'last_name': this.last_name,
      'email_address': this.email_address,
      'phone_number': this.phone_number,
      'reference_id': this.reference_id,
      'company_name': this.company_name,
      'creation_source': this.creation_source,
      'version': this.version,
    };
  }

  factory Customers_cc.fromMap(Map<String, dynamic> map) {
    return Customers_cc(
      id: map['id'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      first_name: map['first_name'] as String,
      second_name: map['second_name'] as String,
      last_name: map['last_name'] as String,
      email_address: map['email_address'] as String,
      phone_number: map['phone_number'] as String,
      reference_id: map['reference_id'] as String,
      company_name: map['company_name'] as String,
      creation_source: map['creation_source'] as String,
      version: map['version'] as String,
    );
  }

//</editor-fold>
}