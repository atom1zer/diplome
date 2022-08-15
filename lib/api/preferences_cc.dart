class Preferences{

  bool email_unsubscribed;


  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      email_unsubscribed: json['email_unsubscribed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email_unsubscribed': email_unsubscribed,

    };
  }

//<editor-fold desc="Data Methods">

  Preferences({
    required this.email_unsubscribed,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preferences &&
          runtimeType == other.runtimeType &&
          email_unsubscribed == other.email_unsubscribed);

  @override
  int get hashCode => email_unsubscribed.hashCode;

  @override
  String toString() {
    return 'Preferences{' + ' email_unsubscribed: $email_unsubscribed,' + '}';
  }

  Preferences copyWith({
    bool? email_unsubscribed,
  }) {
    return Preferences(
      email_unsubscribed: email_unsubscribed ?? this.email_unsubscribed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email_unsubscribed': this.email_unsubscribed,
    };
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      email_unsubscribed: map['email_unsubscribed'] as bool,
    );
  }

//</editor-fold>
}