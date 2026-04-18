import '../providers/hive_provider.dart';
import '../models/movie_model.dart';

class WatchlistService {
  final _box = HiveProvider.getWatchlistBox();

  List<MovieItem> getAllMovies() {
    return _box.values.toList();
  }

  Future<void> addMovie(MovieItem movie) async {
    await _box.put(movie.id, movie);
  }

  Future<void> deleteMovie(dynamic key) async {
    await _box.delete(key);
  }
}