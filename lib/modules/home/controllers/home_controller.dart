import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/utils/app_snackbar.dart';
import '../../../data/services/movie_service.dart';

enum MediaTab { movies, tvShows }

enum HomeCategory { browse, trending, popular, updated, genre, random }

enum HomeMediaFilter { all, movies, series }

class HomeController extends GetxController {
  static const int _initialPageCount = 2;
  static const int visiblePageButtonCount = 5;

  final selectedCategory = HomeCategory.trending.obs;
  final selectedMediaFilter = HomeMediaFilter.all.obs;
  final selectedGenreId = RxnInt();
  final selectedGenreLabel = RxnString();
  final randomMediaTab = Rxn<MediaTab>();
  final randomGenreId = RxnInt();
  final randomGenreLabel = RxnString();
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMoreContent = true.obs;
  final contentItems = <dynamic>[].obs;
  final currentPage = 0.obs;
  final currentDisplayPage = 1.obs;

  bool get isGenreBrowserMode =>
      selectedCategory.value == HomeCategory.genre &&
      selectedGenreId.value == null;

  String get currentScreenTitle {
    if (selectedCategory.value == HomeCategory.random) {
      final mediaLabel = randomMediaTab.value == MediaTab.tvShows
          ? 'Series'
          : 'Movies';
      final genreLabel = randomGenreLabel.value;
      if (genreLabel == null || genreLabel.isEmpty) {
        return 'Random';
      }
      return 'Random - $mediaLabel - $genreLabel';
    }

    if (selectedCategory.value == HomeCategory.genre) {
      if (selectedGenreLabel.value != null && selectedGenreLabel.value!.isNotEmpty) {
        return '${selectedGenreLabel.value}${_mediaSuffix}';
      }
      return 'Genre${_mediaSuffix}';
    }

    return '${_categoryLabel(selectedCategory.value)}$_mediaSuffix';
  }

  String get _mediaSuffix {
    switch (selectedMediaFilter.value) {
      case HomeMediaFilter.all:
        return '';
      case HomeMediaFilter.movies:
        return ' - Movies';
      case HomeMediaFilter.series:
        return ' - Series';
    }
  }

  @override
  void onInit() {
    super.onInit();
    _applySavedPreferences();
    getContent();
  }

  void _applySavedPreferences() {
    final settingsBox = Hive.box(AppConstants.settingsBox);
    final preferredContentType = settingsBox.get(
      AppConstants.preferredContentTypeKey,
      defaultValue: 'all',
    ) as String;
    final defaultHomeSection = settingsBox.get(
      AppConstants.defaultHomeSectionKey,
      defaultValue: 'trending',
    ) as String;

    selectedMediaFilter.value = switch (preferredContentType) {
      'movies' => HomeMediaFilter.movies,
      'series' => HomeMediaFilter.series,
      _ => HomeMediaFilter.all,
    };

    selectedCategory.value = switch (defaultHomeSection) {
      'browse' => HomeCategory.browse,
      'popular' => HomeCategory.popular,
      'updated' => HomeCategory.updated,
      'genre' => HomeCategory.genre,
      _ => HomeCategory.trending,
    };
  }

  void selectCategory(
    HomeCategory category, {
    HomeMediaFilter? mediaFilter,
  }) {
    selectedCategory.value = category;
    selectedMediaFilter.value = mediaFilter ?? HomeMediaFilter.all;
    selectedGenreId.value = null;
    selectedGenreLabel.value = null;
    currentDisplayPage.value = 1;

    if (category != HomeCategory.random) {
      randomMediaTab.value = null;
      randomGenreId.value = null;
      randomGenreLabel.value = null;
    }

    if (category == HomeCategory.genre) {
      isLoading(false);
      hasMoreContent.value = false;
      return;
    }

    getContent();
  }

  void selectGenre({
    required HomeMediaFilter mediaFilter,
    required int genreId,
    required String genreLabel,
  }) {
    selectedCategory.value = HomeCategory.genre;
    selectedMediaFilter.value = mediaFilter;
    selectedGenreId.value = genreId;
    selectedGenreLabel.value = genreLabel;
    currentDisplayPage.value = 1;
    getContent();
  }

  void applyRandomSelection({
    required MediaTab mediaTab,
    required int genreId,
    required String genreLabel,
  }) {
    selectedCategory.value = HomeCategory.random;
    randomMediaTab.value = mediaTab;
    randomGenreId.value = genreId;
    randomGenreLabel.value = genreLabel;
    selectedGenreId.value = null;
    selectedGenreLabel.value = null;
    currentDisplayPage.value = 1;
    getContent();
  }

  Future<void> getContent() async {
    try {
      isLoading(true);
      hasMoreContent.value = true;
      currentPage.value = 0;
      currentDisplayPage.value = 1;

      final items = <dynamic>[];
      for (var page = 1; page <= _initialPageCount; page++) {
        final pageItems = await _loadSelectedContent(page: page);
        if (pageItems.isEmpty) {
          hasMoreContent.value = false;
          break;
        }

        items.addAll(pageItems);
        currentPage.value = page;
      }

      contentItems.assignAll(items);
    } catch (e) {
      AppSnackbar.show(
        'Error',
        'Could not load ${currentScreenTitle.toLowerCase()}: $e',
        isError: true,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMoreContent() async {
    if (isLoading.value || isLoadingMore.value || !hasMoreContent.value) {
      return;
    }

    try {
      isLoadingMore(true);
      final nextPage = currentPage.value + 1;
      final pageItems = await _loadSelectedContent(page: nextPage);

      if (pageItems.isEmpty) {
        hasMoreContent.value = false;
        return;
      }

      contentItems.addAll(pageItems);
      currentPage.value = nextPage;
    } catch (e) {
      AppSnackbar.show(
        'Error',
        'Could not load more ${currentScreenTitle.toLowerCase()}: $e',
        isError: true,
      );
    } finally {
      isLoadingMore(false);
    }
  }

  int totalLoadedDisplayPages(int itemsPerPage) {
    if (contentItems.isEmpty) {
      return 1;
    }

    return (contentItems.length / itemsPerPage).ceil();
  }

  List<dynamic> displayItems(int itemsPerPage) {
    final start = (currentDisplayPage.value - 1) * itemsPerPage;
    if (start >= contentItems.length) {
      return [];
    }

    final end = (start + itemsPerPage).clamp(0, contentItems.length);
    return contentItems.sublist(start, end);
  }

  bool get hasPreviousDisplayPage => currentDisplayPage.value > 1;

  Future<void> goToPreviousDisplayPage() async {
    if (!hasPreviousDisplayPage) return;
    currentDisplayPage.value -= 1;
  }

  Future<void> goToNextDisplayPage(int itemsPerPage) async {
    await goToDisplayPage(currentDisplayPage.value + 1, itemsPerPage);
  }

  Future<void> goToDisplayPage(int page, int itemsPerPage) async {
    if (page < 1) return;

    await _ensureItemsForDisplayPage(_visibleWindowEndPage(page), itemsPerPage);
    final maxPage = totalLoadedDisplayPages(itemsPerPage);
    if (page <= maxPage) {
      currentDisplayPage.value = page;
    }
  }

  Future<void> _ensureItemsForDisplayPage(int page, int itemsPerPage) async {
    while (hasMoreContent.value && contentItems.length < page * itemsPerPage) {
      await loadMoreContent();
      if (isLoadingMore.value) {
        break;
      }
    }
  }

  int _visibleWindowEndPage(int page) {
    final step = visiblePageButtonCount - 1;
    final start = (((page - 1) ~/ step) * step) + 1;
    return start + visiblePageButtonCount - 1;
  }

  List<int> visiblePageNumbers(int itemsPerPage) {
    final totalPages = totalLoadedDisplayPages(itemsPerPage);
    final current = currentDisplayPage.value;
    final window = visiblePageButtonCount;
    final step = window - 1;

    if (totalPages <= window) {
      return List<int>.generate(totalPages, (index) => index + 1);
    }

    var start = (((current - 1) ~/ step) * step) + 1;
    var end = start + window - 1;

    if (end > totalPages) {
      end = totalPages;
      start = totalPages - window + 1;
    }

    return List<int>.generate(end - start + 1, (index) => start + index);
  }

  Future<List<dynamic>> _loadSelectedContent({int page = 1}) async {
    switch (selectedCategory.value) {
      case HomeCategory.browse:
        return switch (selectedMediaFilter.value) {
          HomeMediaFilter.movies => MovieService.fetchPopularMovies(page: page),
          HomeMediaFilter.series => MovieService.fetchPopularTvShows(page: page),
          HomeMediaFilter.all => MovieService.fetchBrowseContent(page: page),
        };
      case HomeCategory.trending:
        return switch (selectedMediaFilter.value) {
          HomeMediaFilter.movies => MovieService.fetchTrendingMovies(page: page),
          HomeMediaFilter.series => MovieService.fetchTrendingTvShows(page: page),
          HomeMediaFilter.all => MovieService.fetchTrendingContent(page: page),
        };
      case HomeCategory.popular:
        return switch (selectedMediaFilter.value) {
          HomeMediaFilter.movies => MovieService.fetchPopularMovies(page: page),
          HomeMediaFilter.series => MovieService.fetchPopularTvShows(page: page),
          HomeMediaFilter.all => MovieService.fetchPopularContent(page: page),
        };
      case HomeCategory.updated:
        return switch (selectedMediaFilter.value) {
          HomeMediaFilter.movies => MovieService.fetchNowPlayingMovies(page: page),
          HomeMediaFilter.series => MovieService.fetchUpdatedSeries(page: page),
          HomeMediaFilter.all => MovieService.fetchUpdatedContent(page: page),
        };
      case HomeCategory.genre:
        final genreId = selectedGenreId.value;
        if (genreId == null) {
          return [];
        }

        return switch (selectedMediaFilter.value) {
          HomeMediaFilter.movies => MovieService.fetchMoviesByGenre(
              genreId,
              page: page,
            ),
          HomeMediaFilter.series => MovieService.fetchTvShowsByGenre(
              genreId,
              page: page,
            ),
          HomeMediaFilter.all => MovieService.fetchMoviesByGenre(
              genreId,
              page: page,
            ),
        };
      case HomeCategory.random:
        final mediaTab = randomMediaTab.value;
        final genreId = randomGenreId.value;

        if (mediaTab == null || genreId == null) {
          return [];
        }

        final items = mediaTab == MediaTab.movies
            ? await MovieService.fetchMoviesByGenre(genreId, page: page)
            : await MovieService.fetchTvShowsByGenre(genreId, page: page);

        items.shuffle();
        return items;
    }
  }

  String _categoryLabel(HomeCategory category) {
    switch (category) {
      case HomeCategory.browse:
        return 'Browse';
      case HomeCategory.trending:
        return 'Trending';
      case HomeCategory.popular:
        return 'Popular';
      case HomeCategory.updated:
        return 'Updated';
      case HomeCategory.genre:
        return 'Genre';
      case HomeCategory.random:
        return 'Random';
    }
  }
}
