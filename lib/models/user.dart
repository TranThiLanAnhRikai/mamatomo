import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';


class UserModel {
  int? id;
  String name;
  String password;
  int age;
  String intro;
  String? address;
  Uint8List? imageBytes;

  UserModel({
    this.id,
    required this.name,
    required this.password,
    required this.age,
    required this.intro,
    required this.address,
    this.imageBytes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      password: json['pw'],
      age: json['age'],
      intro: json['intro'],
      address: json['address'],
      imageBytes: json['image'] != null ? File(json['image']).readAsBytesSync() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pw': password,
      'age': age,
      'intro': intro,
      'address': address,
      'image': imageBytes,
    };
  }
}
