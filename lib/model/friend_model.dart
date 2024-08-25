class FriendsModel {
  String fId;
  String userId;
  String fName;
  String lName;
  String fPhoneNumber;
  String? description;
  int? amount;
  int? members;
  bool isExpenseDelete;
  bool isFriendsDelete;

  FriendsModel({
    required this.fId,
    required this.userId,
    required this.fName,
    required this.lName,
    required this.fPhoneNumber,
    this.description,
    this.isExpenseDelete = false,
    this.isFriendsDelete = false,
    this.amount,
    this.members,
  });

  factory FriendsModel.fromJson(Map<String, dynamic> json) => FriendsModel(
        fId: json["fId"],
    userId: json["userId"],
        fName: json["fName"],
        lName: json["lName"],
        fPhoneNumber: json["fPhoneNumber"],
    description: json["description"] as String?,
        amount: json["amount"] as int?,
    members: json["members"] as int?,
    isExpenseDelete: json["isExpenseDelete"] as bool,
    isFriendsDelete: json["isFriendsDelete"] as bool,
      );

  Map<String, dynamic> toJson() => {
        "fId": fId,
        "userId": userId,
        "fName": fName,
        "lName": lName,
        "fPhoneNumber": fPhoneNumber,
        "description": description,
        "amount": amount,
        "members": members,
        "isExpenseDelete": isExpenseDelete,
        "isFriendsDelete": isFriendsDelete,
      };
}
