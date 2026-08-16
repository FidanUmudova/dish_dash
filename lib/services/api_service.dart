import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com/recipes';

  Future<Map<String, dynamic>> fetchRecipes({required int skip, required int limit}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Server error (${response.statusCode}): Failed to load recipes');
    }
  }
}