class UserModel {
  String userId;
  String userName;
  String userEmail;
  String? phoneNumber;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json["userId"],
    userName: json["userName"],
    userEmail: json["userEmail"],
    phoneNumber: json["phoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "userEmail": userEmail,
    "phoneNumber": phoneNumber,
  };
}
