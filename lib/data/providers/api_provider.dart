import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/constants/api_constants.dart'; // Correct: Up to 'data', then 'lib'
class ApiProvider {
  // A generic GET request method to reduce code duplication
  static Future<Map<String, dynamic>> getRequest(String endpoint) async {
    try {
      if (ApiConstants.apiKey.isEmpty) {
        throw Exception(
          'Missing TMDB_API_KEY. Run the app with '
          '--dart-define=TMDB_API_KEY=your_key_here',
        );
      }

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}$endpoint&api_key=${ApiConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        // Successfully parsed JSON data
        return json.decode(response.body);
      } else {
        // Standard API error handling [cite: 9, 29]
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handles no internet or timeout issues [cite: 26, 29]
      throw Exception('Connection failed: $e');
    }
  }
}
