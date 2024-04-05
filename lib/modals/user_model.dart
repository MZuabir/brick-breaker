import 'dart:convert';

class UserModel {
  final String? id;
  final String? name;
  final String? profile;
  final String? score;

  UserModel({
    this.id,
    required this.name,
    required this.profile,
    required this.score,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? profile,
    String? score,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        profile: profile ?? this.profile,
        score: score ?? this.score,
      );

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        profile: json['profile'],
        score: json['score'].toString());
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile": profile,
        "score": int.parse(score ?? '0'),
      };
}
