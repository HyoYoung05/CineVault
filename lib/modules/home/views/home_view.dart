import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; 
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart'; 

import '../controllers/home_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/constants/app_constants.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineVault - Trending'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search), 
            onPressed: () => Get.toNamed(Routes.SEARCH)
          ),
          IconButton(
            icon: const Icon(Icons.bookmark), 
            onPressed: () {
              final settingsBox = Hive.box(AppConstants.settingsBox);
              bool isProtected = settingsBox.get('biometricEnabled', defaultValue: false);

              if (isProtected && !kIsWeb) {
                Get.toNamed(Routes.LOCK, arguments: Routes.WATCHLIST);
              } else {
                Get.toNamed(Routes.WATCHLIST);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings), 
            onPressed: () => Get.toNamed(Routes.SETTINGS)
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.trendingMovies.length,
          itemBuilder: (context, index) {
            var movie = controller.trendingMovies[index];
            String? path = movie['poster_path'];
            bool hasImage = path != null && path.isNotEmpty;
            String posterUrl = hasImage ? 'https://image.tmdb.org/t/p/w500$path' : '';

            return GestureDetector(
              onTap: () => Get.toNamed(Routes.DETAILS, arguments: movie),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: hasImage 
                  ? Image.network(posterUrl, fit: BoxFit.cover)
                  : const Center(child: Icon(Icons.movie, size: 40)),
              ),
            );
          },
        );
      }),
    );
  }
}
