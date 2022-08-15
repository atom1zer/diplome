class Actions_popup{

  String name;
  String url;

//<editor-fold desc="Data Methods">

  Actions_popup({
    required this.name,
    required this.url,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Actions_popup &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          url == other.url);

  @override
  int get hashCode => name.hashCode ^ url.hashCode;

  @override
  String toString() {
    return 'Actions_popup{' + ' name: $name,' + ' url: $url,' + '}';
  }

  Actions_popup copyWith({
    String? name,
    String? url,
  }) {
    return Actions_popup(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'url': this.url,
    };
  }

  factory Actions_popup.fromMap(Map<String, dynamic> map) {
    return Actions_popup(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

//</editor-fold>
}