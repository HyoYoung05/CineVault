import '../providers/api_provider.dart';

class MovieService {
  // Fetches Trending Movies for the Dashboard
  static Future<List<dynamic>> fetchTrending() async {
    try {
      final data = await ApiProvider.getRequest('/trending/movie/day?');
      return data['results'] ?? [];
    } catch (e) {
      rethrow; // Pass the error up to the controller to handle in the UI
    }
  }

  // Searches for movies by title
  static Future<List<dynamic>> searchMovies(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final data = await ApiProvider.getRequest('/search/movie?query=$encodedQuery');
      return data['results'] ?? [];
    } catch (e) {
      rethrow;
    }
  }
}