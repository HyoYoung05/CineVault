import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/constants/api_constants.dart'; // Correct: Up to 'data', then 'lib'
class ApiProvider {
  // A generic GET request method to reduce code duplication
  static Future<Map<String, dynamic>> getRequest(String endpoint) async {
    try {
      final apiKey = ApiConstants.apiKey.trim();
      const placeholderKeys = {'YOUR_API_KEY', 'YOUR_API_KEY_HERE'};

      if (apiKey.isEmpty || placeholderKeys.contains(apiKey)) {
        throw Exception(
          'Missing TMDb API key. Add your real key in '
          'lib/app/constants/api_constants.dart before running the app.',
        );
      }

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}$endpoint&api_key=$apiKey',
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
