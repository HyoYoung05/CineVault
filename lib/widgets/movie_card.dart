import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';

class MovieCard extends StatelessWidget {
  final dynamic movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    String? path = movie['poster_path'];
    bool hasImage = path != null && path.isNotEmpty;
    String posterUrl = hasImage ? 'https://image.tmdb.org/t/p/w500$path' : '';

    return GestureDetector(
      // Centrally handles navigation to the details screen!
      onTap: () => Get.toNamed(Routes.DETAILS, arguments: movie),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: hasImage 
          ? Image.network(
              posterUrl, 
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie, size: 40, color: Colors.grey),
                  Text('No Poster', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
      ),
    );
  }
}