import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/details_controller.dart';

class DetailsView extends GetView<DetailsController> {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = controller.movie;
    final String? path = movie['poster_path'];
    final bool hasImage = path != null && path.isNotEmpty;
    final String posterUrl = hasImage ? 'https://image.tmdb.org/t/p/w500$path' : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title'] ?? 'Movie Details'),
      ),
      
      // --- THE NEW FLOATING ACTION BUTTON ---
      // DetailsView.dart -> floatingActionButton

floatingActionButton: Obx(() {
  return FloatingActionButton.extended(
    // Logic: If saved, optionally call remove, otherwise call add
    onPressed: controller.isSaved.value 
        ? null // Or call controller.removeFromWatchlist, or a different UI flow
        : controller.addToWatchlist,
    
    // --- CONDITIONAL LABEL & ICON ---
    icon: controller.isSaved.value 
        ? const Icon(Icons.bookmark_added) 
        : const Icon(Icons.bookmark_add),
    label: controller.isSaved.value 
        ? const Text('Saved') 
        : const Text('Save to Watchlist'),
        
    backgroundColor: controller.isSaved.value
        ? Colors.grey // Make it look different/inactive
        : Colors.deepPurpleAccent, 
    foregroundColor: Colors.white,
  );
}),
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              Image.network(
                posterUrl,
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(
                  height: 400,
                  child: Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                ),
              )
            else
              const SizedBox(
                height: 400,
                child: Center(child: Icon(Icons.movie, size: 100, color: Colors.grey)),
              ),
              
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'] ?? 'Unknown Title',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Release Date: ${movie['release_date'] ?? 'TBA'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('${movie['vote_average'] ?? 'N/A'} / 10'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie['overview'] ?? 'No overview available.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 80), // Added bottom padding so the FAB doesn't cover text
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}