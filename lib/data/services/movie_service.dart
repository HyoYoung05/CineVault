import '../providers/api_provider.dart';

class MovieService {
  static List<dynamic> _tagMediaType(List<dynamic> items, String mediaType) {
    return items
        .map(
          (item) => {
            ...Map<String, dynamic>.from(item as Map),
            'media_type': mediaType,
          },
        )
        .toList();
  }

  static num _popularityOf(dynamic item) {
    final value = item['popularity'];
    return value is num ? value : 0;
  }

  static Future<List<dynamic>> fetchTrendingMovies({int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest('/trending/movie/day?page=$page');
      return data['results'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchPopularMovies({int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest('/movie/popular?page=$page');
      return data['results'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchTrendingTvShows({int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest('/trending/tv/day?page=$page');
      return data['results'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchPopularTvShows({int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest('/tv/popular?page=$page');
      return data['results'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchTopRatedMovies({int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest('/movie/top_rated?page=$page');
      return data['results'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchUpcomingMovies({int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest('/movie/upcoming?page=$page');
      return data['results'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest('/movie/now_playing?page=$page');
      return _tagMediaType(List<dynamic>.from(data['results'] ?? []), 'movie');
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchAiringTodaySeries({int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest('/tv/airing_today?page=$page');
      return _tagMediaType(List<dynamic>.from(data['results'] ?? []), 'tv');
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchTopRatedTvShows({int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest('/tv/top_rated?page=$page');
      return data['results'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest(
        '/discover/movie?with_genres=$genreId&page=$page',
      );
      return data['results'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchTvShowsByGenre(int genreId, {int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest(
        '/discover/tv?with_genres=$genreId&page=$page',
      );
      return data['results'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchBrowseContent({int page = 1}) async {
    final movieResults = _tagMediaType(
      await fetchPopularMovies(page: page),
      'movie',
    );
    final tvResults = _tagMediaType(
      await fetchPopularTvShows(page: page),
      'tv',
    );

    final combined = [...movieResults, ...tvResults];
    combined.sort(
      (a, b) => (a['title'] ?? a['name'] ?? '')
          .toString()
          .toLowerCase()
          .compareTo((b['title'] ?? b['name'] ?? '').toString().toLowerCase()),
    );
    return combined;
  }

  static Future<List<dynamic>> fetchTrendingContent({int page = 1}) async {
    final movieResults = _tagMediaType(
      await fetchTrendingMovies(page: page),
      'movie',
    );
    final tvResults = _tagMediaType(
      await fetchTrendingTvShows(page: page),
      'tv',
    );

    final combined = [...movieResults, ...tvResults];
    combined.sort((a, b) => _popularityOf(b).compareTo(_popularityOf(a)));
    return combined;
  }

  static Future<List<dynamic>> fetchPopularContent({int page = 1}) async {
    final movieResults = _tagMediaType(
      await fetchPopularMovies(page: page),
      'movie',
    );
    final tvResults = _tagMediaType(
      await fetchPopularTvShows(page: page),
      'tv',
    );

    final combined = [...movieResults, ...tvResults];
    combined.sort((a, b) => _popularityOf(b).compareTo(_popularityOf(a)));
    return combined;
  }

  static Future<List<dynamic>> fetchUpdatedSeries({int page = 1}) async {
    try {
      final data = await ApiProvider.getRequest('/tv/on_the_air?page=$page');
      return _tagMediaType(List<dynamic>.from(data['results'] ?? []), 'tv');
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchUpdatedContent({int page = 1}) async {
    final movieResults = await fetchNowPlayingMovies(page: page);
    final tvResults = await fetchUpdatedSeries(page: page);

    final combined = [...movieResults, ...tvResults];
    combined.sort((a, b) => _popularityOf(b).compareTo(_popularityOf(a)));
    return combined;
  }

  static Future<List<dynamic>> searchMovies(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final data = await ApiProvider.getRequest('/search/multi?query=$encodedQuery');
      final results = List<dynamic>.from(data['results'] ?? []);

      return results
          .where(
            (item) => item['media_type'] == 'movie' || item['media_type'] == 'tv',
          )
          .map((item) {
            if (item['media_type'] == 'tv') {
              return {
                ...item,
                'title': item['name'] ?? item['title'] ?? 'Unknown',
                'release_date': item['first_air_date'] ?? item['release_date'] ?? 'TBA',
                'media_type': 'tv',
              };
            }

            return {
              ...item,
              'title': item['title'] ?? item['name'] ?? 'Unknown',
              'release_date': item['release_date'] ?? item['first_air_date'] ?? 'TBA',
              'media_type': 'movie',
            };
          })
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
