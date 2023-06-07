// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'constants.dart';
// import 'models/user.dart';
//
// class APIService {
//   Future<List<User>> getUsers(String username) async {
//     final url = '${ApiConstants.baseUrl}${ApiConstants.getUsersEndpoint}?username=$username';
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == ApiConstants.getUsersSuccessCode) {
//       final jsonData = json.decode(response.body);
//       return List<User>.from(jsonData.map((user) => User.fromJson(user)));
//     } else {
//       throw Exception('Failed to get users');
//     }
//   }
//
//   Future<User> createUser(User user) async {
//     final url = '${ApiConstants.baseUrl}${ApiConstants.createUserEndpoint}';
//
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(user.toJson()),
//     );
//
//     if (response.statusCode == ApiConstants.createUserSuccessCode) {
//       final jsonData = json.decode(response.body);
//       return User.fromJson(jsonData);
//     } else {
//       throw Exception('Failed to create user');
//     }
//   }
//
// // Implement other API functions here
//
// }
