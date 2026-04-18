/*
import 'package:get/get.dart';
import '../data/services/movie_service.dart';

class MovieController extends GetxController {
  var isLoading = true.obs;
  var isSearching = false.obs;
  var trendingMovies = [].obs;
  var searchResults = [].obs;

  @override
  void onInit() {
    super.onInit();
    getTrending();
  }

  // Uses the service to get trending data
  void getTrending() async {
    try {
      isLoading(true);
      var movies = await MovieService.fetchTrending();
      trendingMovies.assignAll(movies);
    } catch (e) {
      Get.snackbar('Error', 'Could not load trending movies: $e');
    } finally {
      isLoading(false);
    }
  }

  // Uses the service to search
  void search(String query) async {
    try {
      isSearching(true);
      var results = await MovieService.searchMovies(query);
      searchResults.assignAll(results);
    } catch (e) {
      Get.snackbar('Search Error', e.toString());
    } finally {
      isSearching(false);
    }
  }
}
*/