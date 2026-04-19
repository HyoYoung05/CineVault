import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../../data/services/movie_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/responsive_app_bar_title.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const List<Map<String, dynamic>> _movieGenres = [
    {'label': 'Action', 'id': 28, 'icon': Icons.bolt_outlined},
    {'label': 'Adventure', 'id': 12, 'icon': Icons.explore_outlined},
    {'label': 'Animation', 'id': 16, 'icon': Icons.animation_outlined},
    {'label': 'Comedy', 'id': 35, 'icon': Icons.sentiment_very_satisfied_outlined},
    {'label': 'Crime', 'id': 80, 'icon': Icons.gavel_outlined},
    {'label': 'Documentary', 'id': 99, 'icon': Icons.menu_book_outlined},
    {'label': 'Drama', 'id': 18, 'icon': Icons.theater_comedy_outlined},
    {'label': 'Family', 'id': 10751, 'icon': Icons.family_restroom_outlined},
    {'label': 'Fantasy', 'id': 14, 'icon': Icons.auto_awesome_outlined},
    {'label': 'History', 'id': 36, 'icon': Icons.account_balance_outlined},
    {'label': 'Horror', 'id': 27, 'icon': Icons.nightlight_round},
    {'label': 'Music', 'id': 10402, 'icon': Icons.music_note_outlined},
    {'label': 'Mystery', 'id': 9648, 'icon': Icons.psychology_outlined},
    {'label': 'Romance', 'id': 10749, 'icon': Icons.favorite_border},
    {'label': 'Sci-Fi', 'id': 878, 'icon': Icons.rocket_launch_outlined},
    {'label': 'Thriller', 'id': 53, 'icon': Icons.flash_on_outlined},
    {'label': 'War', 'id': 10752, 'icon': Icons.shield_outlined},
    {'label': 'Western', 'id': 37, 'icon': Icons.landscape_outlined},
  ];

  static const List<Map<String, dynamic>> _tvGenres = [
    {'label': 'Action & Adventure', 'id': 10759, 'icon': Icons.bolt_outlined},
    {'label': 'Animation', 'id': 16, 'icon': Icons.animation_outlined},
    {'label': 'Comedy', 'id': 35, 'icon': Icons.sentiment_very_satisfied_outlined},
    {'label': 'Crime', 'id': 80, 'icon': Icons.gavel_outlined},
    {'label': 'Documentary', 'id': 99, 'icon': Icons.menu_book_outlined},
    {'label': 'Drama', 'id': 18, 'icon': Icons.theater_comedy_outlined},
    {'label': 'Family', 'id': 10751, 'icon': Icons.family_restroom_outlined},
    {'label': 'Kids', 'id': 10762, 'icon': Icons.child_care_outlined},
    {'label': 'Mystery', 'id': 9648, 'icon': Icons.psychology_outlined},
    {'label': 'News', 'id': 10763, 'icon': Icons.newspaper_outlined},
    {'label': 'Reality', 'id': 10764, 'icon': Icons.visibility_outlined},
    {'label': 'Sci-Fi & Fantasy', 'id': 10765, 'icon': Icons.rocket_launch_outlined},
    {'label': 'Soap', 'id': 10766, 'icon': Icons.water_drop_outlined},
    {'label': 'Talk', 'id': 10767, 'icon': Icons.record_voice_over_outlined},
    {'label': 'War & Politics', 'id': 10768, 'icon': Icons.shield_outlined},
    {'label': 'Western', 'id': 37, 'icon': Icons.landscape_outlined},
  ];

  Map<String, dynamic> _normalizeMediaItem(dynamic item) {
    final map = Map<String, dynamic>.from(item as Map);
    final inferredMediaType = map['media_type'] ??
        (map['name'] != null && map['title'] == null ? 'tv' : 'movie');
    final title = map['title'] ?? map['name'] ?? 'Unknown Title';
    final releaseDate = map['release_date'] ?? map['first_air_date'] ?? 'TBA';

    map['title'] = title;
    map['name'] = map['name'] ?? title;
    map['release_date'] = releaseDate;
    map['first_air_date'] = map['first_air_date'] ?? releaseDate;
    map['media_type'] = inferredMediaType;
    return map;
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required HomeCategory category,
    required HomeMediaFilter mediaFilter,
  }) {
    final isSelected = controller.selectedCategory.value == category &&
        controller.selectedMediaFilter.value == mediaFilter &&
        !controller.isGenreBrowserMode;

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 16),
      leading: Icon(icon),
      title: Text(title),
      selected: isSelected,
      onTap: () {
        Navigator.of(context).pop();
        controller.selectCategory(category, mediaFilter: mediaFilter);
      },
    );
  }

  Widget _buildGenreItem({
    required BuildContext context,
    required HomeMediaFilter mediaFilter,
  }) {
    final isSelected = controller.selectedCategory.value == HomeCategory.genre &&
        controller.selectedMediaFilter.value == mediaFilter &&
        controller.selectedGenreId.value == null;

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 16),
      leading: const Icon(Icons.tune),
      title: const Text('Genre'),
      selected: isSelected,
      onTap: () {
        Navigator.of(context).pop();
        controller.selectCategory(HomeCategory.genre, mediaFilter: mediaFilter);
      },
    );
  }

  Widget _buildMediaSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required HomeMediaFilter mediaFilter,
  }) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      childrenPadding: EdgeInsets.zero,
      children: [
        _buildNavItem(
          context: context,
          icon: Icons.dashboard_outlined,
          title: 'Browse',
          category: HomeCategory.browse,
          mediaFilter: mediaFilter,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.trending_up,
          title: 'Trending',
          category: HomeCategory.trending,
          mediaFilter: mediaFilter,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.local_fire_department_outlined,
          title: 'Popular',
          category: HomeCategory.popular,
          mediaFilter: mediaFilter,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.update_outlined,
          title: 'Updated',
          category: HomeCategory.updated,
          mediaFilter: mediaFilter,
        ),
        _buildGenreItem(
          context: context,
          mediaFilter: mediaFilter,
        ),
      ],
    );
  }

  Widget _buildGenreBrowserSection({
    required String title,
    required HomeMediaFilter mediaFilter,
    required List<Map<String, dynamic>> genres,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> _loadGenrePreview(
    HomeMediaFilter mediaFilter,
    int genreId,
  ) async {
    final items = mediaFilter == HomeMediaFilter.movies
        ? await MovieService.fetchMoviesByGenre(genreId)
        : await MovieService.fetchTvShowsByGenre(genreId);
    return items.take(4).toList();
  }

  Widget _buildGenrePreviewGrid({
    required HomeMediaFilter mediaFilter,
    required List<Map<String, dynamic>> genres,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 230,
          childAspectRatio: 0.72,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final genre = genres[index];
            return _buildGenrePreviewCard(
              mediaFilter: mediaFilter,
              genreId: genre['id'] as int,
              genreLabel: genre['label'] as String,
              icon: genre['icon'] as IconData,
            );
          },
          childCount: genres.length,
        ),
      ),
    );
  }

  Widget _buildGenrePreviewCard({
    required HomeMediaFilter mediaFilter,
    required int genreId,
    required String genreLabel,
    required IconData icon,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: () => controller.selectGenre(
          mediaFilter: mediaFilter,
          genreId: genreId,
          genreLabel: genreLabel,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<List<dynamic>>(
              future: _loadGenrePreview(mediaFilter, genreId),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const [];

                if (snapshot.connectionState == ConnectionState.waiting &&
                    items.isEmpty) {
                  return Container(
                    color: Colors.grey.shade900,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (items.isEmpty) {
                  return Container(
                    color: Colors.grey.shade900,
                    child: Center(
                      child: Icon(
                        icon,
                        size: 48,
                        color: Colors.white70,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final item = index < items.length ? items[index] : null;
                    final posterPath = item?['poster_path'] as String?;
                    final hasPoster = posterPath != null && posterPath.isNotEmpty;

                    if (!hasPoster) {
                      return Container(
                        color: Colors.grey.shade800,
                        child: Icon(icon, color: Colors.white54),
                      );
                    }

                    return Image.network(
                      'https://image.tmdb.org/t/p/w342$posterPath',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade800,
                        child: Icon(icon, color: Colors.white54),
                      ),
                    );
                  },
                );
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.08),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      genreLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRandomDialog(BuildContext context) async {
    var selectedMedia = controller.randomMediaTab.value ?? MediaTab.movies;
    var genres = selectedMedia == MediaTab.movies ? _movieGenres : _tvGenres;
    var selectedGenre = genres.first;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Random Recommendations'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<MediaTab>(
                    value: selectedMedia,
                    decoration: const InputDecoration(labelText: 'Watch type'),
                    items: const [
                      DropdownMenuItem(
                        value: MediaTab.movies,
                        child: Text('Movies'),
                      ),
                      DropdownMenuItem(
                        value: MediaTab.tvShows,
                        child: Text('Series'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedMedia = value;
                        genres = value == MediaTab.movies ? _movieGenres : _tvGenres;
                        selectedGenre = genres.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedGenre['id'] as int,
                    decoration: const InputDecoration(labelText: 'Genre'),
                    items: genres
                        .map(
                          (genre) => DropdownMenuItem<int>(
                            value: genre['id'] as int,
                            child: Text(genre['label'] as String),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedGenre = genres.firstWhere(
                          (genre) => genre['id'] == value,
                        );
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop({
                    'media': selectedMedia,
                    'genreId': selectedGenre['id'],
                    'genreLabel': selectedGenre['label'],
                  }),
                  child: const Text('Show Picks'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;

    controller.applyRandomSelection(
      mediaTab: result['media'] as MediaTab,
      genreId: result['genreId'] as int,
      genreLabel: result['genreLabel'] as String,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => ResponsiveAppBarTitle(controller.currentScreenTitle)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(Routes.SEARCH),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(Routes.SETTINGS),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Obx(
            () => ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 92,
                  child: DrawerHeader(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                    decoration: BoxDecoration(color: Colors.black87),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Browse CineVault',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  title: 'Browse',
                  category: HomeCategory.browse,
                  mediaFilter: HomeMediaFilter.all,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.trending_up,
                  title: 'Trending',
                  category: HomeCategory.trending,
                  mediaFilter: HomeMediaFilter.all,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.local_fire_department_outlined,
                  title: 'Popular',
                  category: HomeCategory.popular,
                  mediaFilter: HomeMediaFilter.all,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.update_outlined,
                  title: 'Updated',
                  category: HomeCategory.updated,
                  mediaFilter: HomeMediaFilter.all,
                ),
                _buildGenreItem(
                  context: context,
                  mediaFilter: HomeMediaFilter.all,
                ),
                const Divider(),
                _buildMediaSection(
                  context: context,
                  title: 'Movies',
                  icon: Icons.movie_outlined,
                  mediaFilter: HomeMediaFilter.movies,
                ),
                _buildMediaSection(
                  context: context,
                  title: 'Series',
                  icon: Icons.live_tv_outlined,
                  mediaFilter: HomeMediaFilter.series,
                ),
                const Divider(),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 24, right: 16),
                  leading: const Icon(Icons.shuffle_outlined),
                  title: const Text('Random'),
                  selected: controller.selectedCategory.value == HomeCategory.random,
                  onTap: () {
                    Navigator.of(context).pop();
                    _showRandomDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        final width = MediaQuery.of(context).size.width;
        final itemsPerPage = width >= 900 ? 16 : 12;

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isGenreBrowserMode) {
          final showMovies = controller.selectedMediaFilter.value != HomeMediaFilter.series;
          final showSeries = controller.selectedMediaFilter.value != HomeMediaFilter.movies;

          return CustomScrollView(
            slivers: [
              if (showMovies) ...[
                _buildGenreBrowserSection(
                  title: 'Movie Genres',
                  mediaFilter: HomeMediaFilter.movies,
                  genres: _movieGenres,
                ),
                _buildGenrePreviewGrid(
                  mediaFilter: HomeMediaFilter.movies,
                  genres: _movieGenres,
                ),
              ],
              if (showSeries) ...[
                _buildGenreBrowserSection(
                  title: 'Series Genres',
                  mediaFilter: HomeMediaFilter.series,
                  genres: _tvGenres,
                ),
                _buildGenrePreviewGrid(
                  mediaFilter: HomeMediaFilter.series,
                  genres: _tvGenres,
                ),
              ],
            ],
          );
        }

        if (controller.selectedCategory.value == HomeCategory.random &&
            controller.randomGenreId.value == null) {
          return const Center(
            child: Text('Pick Random from the sidebar to get recommendations.'),
          );
        }

        if (controller.contentItems.isEmpty) {
          return Center(
            child: Text('No results found for ${controller.currentScreenTitle}.'),
          );
        }

        final visibleItems = controller.displayItems(itemsPerPage);
        final pageNumbers = controller.visiblePageNumbers(itemsPerPage);
        final showPagination =
            controller.totalLoadedDisplayPages(itemsPerPage) > 1 ||
            controller.hasMoreContent.value;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final media = _normalizeMediaItem(visibleItems[index]);
                    final String? path = media['poster_path'];
                    final bool hasImage = path != null && path.isNotEmpty;
                    final String posterUrl = hasImage
                        ? 'https://image.tmdb.org/t/p/w500$path'
                        : '';

                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        Routes.DETAILS,
                        arguments: media,
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: hasImage
                            ? Image.network(posterUrl, fit: BoxFit.cover)
                            : Center(
                                child: Icon(
                                  media['media_type'] == 'tv'
                                      ? Icons.live_tv
                                      : Icons.movie,
                                  size: 40,
                                ),
                              ),
                      ),
                    );
                  },
                  childCount: visibleItems.length,
                ),
              ),
            ),
            if (showPagination)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: Align(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  OutlinedButton(
                                    onPressed: controller.hasPreviousDisplayPage
                                        ? controller.goToPreviousDisplayPage
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(72, 40),
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                    ),
                                    child: const Text('Previous'),
                                  ),
                                  const SizedBox(width: 8),
                                  for (var i = 0; i < pageNumbers.length; i++) ...[
                                    FilledButton.tonal(
                                      onPressed:
                                          controller.currentDisplayPage.value == pageNumbers[i]
                                              ? null
                                              : () => controller.goToDisplayPage(
                                                    pageNumbers[i],
                                                    itemsPerPage,
                                                  ),
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            controller.currentDisplayPage.value == pageNumbers[i]
                                                ? Theme.of(context).colorScheme.primary
                                                : null,
                                        foregroundColor:
                                            controller.currentDisplayPage.value == pageNumbers[i]
                                                ? Colors.white
                                                : null,
                                        minimumSize: const Size(40, 40),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                      ),
                                      child: Text('${pageNumbers[i]}'),
                                    ),
                                    if (i != pageNumbers.length - 1) const SizedBox(width: 8),
                                  ],
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: controller.isLoadingMore.value
                                        ? null
                                        : () => controller.goToNextDisplayPage(itemsPerPage),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(72, 40),
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                    ),
                                    child: controller.isLoadingMore.value
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Text('Next'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
