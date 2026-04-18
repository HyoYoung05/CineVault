import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/watchlist_controller.dart';
import '../../../app/routes/app_routes.dart';

class WatchlistView extends GetView<WatchlistController> {
  const WatchlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Private Vault'),
        // Explicitly ensuring the back button is here
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.savedMovies.isEmpty) {
          return const Center(child: Text("Your vault is empty."));
        }

        return ListView.separated(
          itemCount: controller.savedMovies.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final movieItem = controller.savedMovies[index];
            final dynamic movieData = {
              'id': movieItem.id,
              'title': movieItem.title,
              'poster_path': movieItem.posterPath,
              'overview': movieItem.overview,
              'release_date': movieItem.releaseDate,
              'vote_average': movieItem.voteAverage,
            };

            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: movieItem.posterPath.isNotEmpty
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w185${movieItem.posterPath}',
                        fit: BoxFit.cover,
                        width: 50,
                        height: 75,
                        errorBuilder: (_, __, ___) => Container(
                          width: 50,
                          height: 75,
                          color: Colors.grey,
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 75,
                        color: Colors.grey,
                      ),
              ),
              title: Text(
                movieItem.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                movieItem.isWatched ? 'Watched' : movieItem.releaseDate,
                style: TextStyle(
                  color: movieItem.isWatched ? Colors.green : Colors.grey,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      movieItem.isWatched
                          ? Icons.visibility
                          : Icons.remove_red_eye_outlined,
                      color: movieItem.isWatched ? Colors.green : Colors.grey,
                    ),
                    onPressed: () => controller.toggleWatched(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => controller.deleteMovie(
                      movieItem.id,
                      movieItem.title,
                    ),
                  ),
                ],
              ),
              onTap: () => Get.toNamed(Routes.DETAILS, arguments: movieData),
            );
          },
        );
      }),
    );
  }
}
