class Item_exp{
  final String id;
  final String name;

  Item_exp({required this.id, required this.name,});


  factory Item_exp.fromJson(Map<String, dynamic> json) {
    // if (json == null) return null;
    return Item_exp(
      id: json["id"],
      name: json["name"],
    );
  }

  static List<Item_exp> fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => Item_exp.fromJson(item)).toList();
  }


  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  /*bool? userFilterByCreationDate(String filter) {
    return this?.createdAt?.toString()?.contains(filter);
  }*/

  ///custom comparing function to check if two users are equal
  bool isEqual(Item_exp model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;


}
/*class UserModel {
  final String id;

  final String name;


  UserModel({required this.id, required this.name,});

  factory UserModel.fromJson(Map<String, dynamic> json) {
   // if (json == null) return null;
    return UserModel(
      id: json["id"],
      name: json["name"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  /*bool userFilterByCreationDate(String filter) {
    return this?.createdAt?.toString()?.contains(filter);
  }*/

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;}*/
