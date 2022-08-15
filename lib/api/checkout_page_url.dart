class Checkout_page_url{

  String checkout_page_url;
  String redirect_url;


  factory Checkout_page_url.fromJson(Map<String, dynamic> json) {
    return Checkout_page_url(
      checkout_page_url: json['checkout_page_url'] as String,
      redirect_url: json['redirect_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'checkout_page_url': checkout_page_url,
      'redirect_url': redirect_url,
    };
  }


//<editor-fold desc="Data Methods">

  Checkout_page_url({
    required this.checkout_page_url,
    required this.redirect_url,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Checkout_page_url &&
          runtimeType == other.runtimeType &&
          checkout_page_url == other.checkout_page_url &&
          redirect_url == other.redirect_url);

  @override
  int get hashCode => checkout_page_url.hashCode ^ redirect_url.hashCode;

  @override
  String toString() {
    return 'Checkout_page_url{' +
        ' checkout_page_url: $checkout_page_url,' +
        ' redirect_url: $redirect_url,' +
        '}';
  }

  Checkout_page_url copyWith({
    String? checkout_page_url,
    String? redirect_url,
  }) {
    return Checkout_page_url(
      checkout_page_url: checkout_page_url ?? this.checkout_page_url,
      redirect_url: redirect_url ?? this.redirect_url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'checkout_page_url': this.checkout_page_url,
      'redirect_url': this.redirect_url,
    };
  }

  factory Checkout_page_url.fromMap(Map<String, dynamic> map) {
    return Checkout_page_url(
      checkout_page_url: map['checkout_page_url'] as String,
      redirect_url: map['redirect_url'] as String,
    );
  }

//</editor-fold>
}