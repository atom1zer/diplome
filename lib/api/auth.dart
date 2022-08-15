class Auth{
  String email;
  String password;


  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }


//<editor-fold desc="Data Methods">

  Auth({
    required this.email,
    required this.password,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Auth &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password);

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  @override
  String toString() {
    return 'Ayth{' + ' email: $email,' + ' password: $password,' + '}';
  }

  Auth copyWith({
    String? email,
    String? password,
  }) {
    return Auth(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'password': this.password,
    };
  }

  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

//</editor-fold>
}