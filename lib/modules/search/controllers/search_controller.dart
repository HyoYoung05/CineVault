import 'package:get/get.dart';
import '../../../../data/services/movie_service.dart';
import '../../../app/utils/app_snackbar.dart';

class SearchModuleController extends GetxController {
  var isSearching = false.obs;
  var searchResults = [].obs;

  // Uses the central MovieService [cite: 21, 25]
  void runSearch(String query) async {
    try {
      isSearching(true);
      var results = await MovieService.searchMovies(query);
      searchResults.assignAll(results);
    } catch (e) {
      AppSnackbar.show('Search Error', 'Failed to fetch results: $e', isError: true);
    } finally {
      isSearching(false);
    }
  }
}
