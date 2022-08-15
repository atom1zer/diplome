class Create_checkout{
  String order_id;
  String redirect_url;


  factory Create_checkout.fromJson(Map<String, dynamic> json) {
    return Create_checkout(
      order_id: json['order_id'] as String,
      redirect_url: json['redirect_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'order_id': order_id,
      'redirect_url': redirect_url,
    };
  }


//<editor-fold desc="Data Methods">

  Create_checkout({
    required this.order_id,
    required this.redirect_url,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Create_checkout &&
          runtimeType == other.runtimeType &&
          order_id == other.order_id &&
          redirect_url == other.redirect_url);

  @override
  int get hashCode => order_id.hashCode ^ redirect_url.hashCode;

  @override
  String toString() {
    return 'Create_checkout{' +
        ' order_id: $order_id,' +
        ' redirect_url: $redirect_url,' +
        '}';
  }

  Create_checkout copyWith({
    String? order_id,
    String? redirect_url,
  }) {
    return Create_checkout(
      order_id: order_id ?? this.order_id,
      redirect_url: redirect_url ?? this.redirect_url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_id': this.order_id,
      'redirect_url': this.redirect_url,
    };
  }

  factory Create_checkout.fromMap(Map<String, dynamic> map) {
    return Create_checkout(
      order_id: map['order_id'] as String,
      redirect_url: map['redirect_url'] as String,
    );
  }

//</editor-fold>
}