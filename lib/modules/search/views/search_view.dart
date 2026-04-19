import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/responsive_app_bar_title.dart';

class SearchView extends GetView<SearchModuleController> {
  SearchView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  void _onSearchSubmit() {
    if (_formKey.currentState!.validate()) {
      controller.runSearch(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveAppBarTitle('Search CineVault'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search movies and TV shows...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _onSearchSubmit,
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty) 
                    ? 'Please enter a title' : null,
                onFieldSubmitted: (_) => _onSearchSubmit(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) return const Center(child: CircularProgressIndicator());
              if (controller.searchResults.isEmpty) return const Center(child: Text('No results found.'));

              return ListView.separated(
                itemCount: controller.searchResults.length,
                separatorBuilder: (context, index) => const Divider(height: 1), // Adds a subtle line between items
                itemBuilder: (context, index) {
                  var movie = controller.searchResults[index];
                  final isTvShow = movie['media_type'] == 'tv';
                  
                  // Extract the image path safely
                  String? path = movie['poster_path'];
                  bool hasImage = path != null && path.isNotEmpty;
                  String posterUrl = hasImage ? 'https://image.tmdb.org/t/p/w185$path' : '';

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    
                    // --- THE MOVIE COVER IMAGE ---
                    leading: Container(
                      width: 50,
                      height: 75,
                      clipBehavior: Clip.antiAlias, // Smoothly rounds the image corners
                      decoration: BoxDecoration(
                        color: Colors.grey[900], // Placeholder background
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: hasImage 
                        ? Image.network(
                            posterUrl, 
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Center(child: Icon(Icons.broken_image, size: 20, color: Colors.grey)),
                          )
                        : const Center(child: Icon(Icons.movie, size: 30, color: Colors.grey)),
                    ),
                    
                    title: Text(movie['title'] ?? 'Unknown'),
                    subtitle: Text(
                      '${isTvShow ? 'TV Show' : 'Movie'} - ${movie['release_date'] ?? 'TBA'}',
                      style: const TextStyle(color: Colors.grey),
                    ), 
                    
                    onTap: () => Get.toNamed(Routes.DETAILS, arguments: movie),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
