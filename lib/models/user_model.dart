class UserModel {
  final String? userId;
  final String? email;
  final String? userName;
  final List<String>? postIds;
  UserModel({this.userId, this.email, this.userName, this.postIds});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        userId: map["userId"],
        email: map["email"],
        userName: map["userName"],
        postIds: List<String>.from(map['postIds'] ?? []));
  }

  Map<String, dynamic> toMap() {
    final classMap = _createMap();
    final Map<String, dynamic> map = {};
    for (MapEntry<String, dynamic> entry in classMap.entries) {
      if (entry.value != null) {
        map.addEntries([entry]);
      }
    }
    return map;
  }

  Map<String, dynamic> _createMap() {
    return {
      "userId": userId,
      "email": email,
      "userName": userName,
      "postIds": postIds,
    };
  }

  UserModel copyWith(
      {String? userId,
      String? email,
      String? userName,
      List<String>? postIds}) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      postIds: postIds ?? this.postIds,
    );
  }
}
