import 'package:get/get.dart';
import '../../../data/services/movie_service.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var trendingMovies = [].obs;

  @override
  void onInit() {
    super.onInit();
    getTrending();
  }

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
}