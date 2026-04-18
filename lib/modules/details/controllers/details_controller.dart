import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../app/constants/app_constants.dart';
import '../../../data/models/movie_model.dart';

class DetailsController extends GetxController {
  late final dynamic movie;
  // --- NEW OBSERVABLE VARIABLE ---
  var isSaved = false.obs;
  late final Box<MovieItem> watchlistBox;

  @override
  void onInit() {
    super.onInit();
    movie = Get.arguments ?? {};
    // Open the box here to avoid re-opening it in every function
    watchlistBox = Hive.box<MovieItem>(AppConstants.watchlistBox);
    // --- CHECK SAVED STATE ON INIT ---
    checkSavedState();
  }

  // Helper to construct the key for checking existence (assumes MovieData uses 'id')
  int getMovieId() {
    return (movie['id'] is int) ? movie['id'] : int.tryParse(movie['id'].toString()) ?? 0;
  }

  void checkSavedState() {
    final int movieId = getMovieId();
    isSaved.value = watchlistBox.containsKey(movieId);
  }

  void addToWatchlist() {
    try {
      final item = MovieItem(
        id: getMovieId(),
        title: movie['title'] ?? 'Unknown',
        posterPath: movie['poster_path'] ?? '',
        // SAVE THE REAL DATA HERE:
        overview: movie['overview'] ?? 'No overview available.',
        releaseDate: movie['release_date'] ?? 'TBA',
        voteAverage: movie['vote_average'] ?? 'N/A',
      );

      watchlistBox.put(item.id, item);
      isSaved.value = true;
      
      Get.snackbar('Saved to Vault', '${item.title} added to your Watchlist.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save movie: $e');
    }
  }

  // Optional: Function to remove from watchlist as well
  void removeFromWatchlist() {
    try {
      final int movieId = getMovieId();
      watchlistBox.delete(movieId);
      isSaved.value = false;
      
      Get.snackbar(
        'Removed from Vault', 
        '${movie['title']} removed from your Watchlist.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove movie: $e');
    }
  }
}