import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/movie_model.dart';

class WatchlistController extends GetxController {
  late Box<MovieItem> watchlistBox;
  var savedMovies = <MovieItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    watchlistBox = Hive.box<MovieItem>('watchlist');
    loadMovies();
  }

  void loadMovies() {
    savedMovies.assignAll(watchlistBox.values.toList());
  }

  void toggleWatched(int index) {
    final movie = savedMovies[index];
    movie.isWatched = !movie.isWatched;

    watchlistBox.put(movie.id, movie);
    savedMovies[index] = movie;
    savedMovies.refresh();
  }

  void deleteMovie(int movieId, String title) {
    watchlistBox.delete(movieId);
    loadMovies();
    Get.snackbar(
      'Removed',
      '$title removed from vault',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: const Color(0xFFFFFFFF),
    );
  }
}
