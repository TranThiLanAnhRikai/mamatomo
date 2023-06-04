import 'dart:typed_data';

class ChildModel {
  String name;
  int genderId;
  int days;

  ChildModel({
    required this.name,
    required this.genderId,
    required this.days,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      name: json['name'],
      genderId: json['gender_id'],
      days: json['days'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender_id': genderId,
      'days': days,
    };
  }
}

