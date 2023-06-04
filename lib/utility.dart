import 'dart:convert';

class Utility {
  static String base64String(List<int> bytes) {
    return base64Encode(bytes);
  }
}