class GroupModel {
  String groupId;
  String groupName;
  String groupType;

  GroupModel({
    required this.groupId,
    required this.groupName,
    required this.groupType,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        groupId: json["groupId"],
        groupName: json["groupName"],
        groupType: json["groupType"],
      );

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "groupName": groupName,
        "groupType": groupType,
      };
}
