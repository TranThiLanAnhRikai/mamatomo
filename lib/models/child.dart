import 'dart:typed_data';

class ChildModel {
  String name;
  int genderId;
  String birthday;

  ChildModel({
    required this.name,
    required this.genderId,
    required this.birthday,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      name: json['name'],
      genderId: json['gender_id'],
      birthday: json['birthday'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender_id': genderId,
      'birthday': birthday,
    };
  }
}

