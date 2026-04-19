import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/utils/app_snackbar.dart';
import '../../../data/models/movie_model.dart';

enum VaultFilter { all, watched, unwatched }

enum ArchiveMediaFilter { all, movies, series }
enum VaultSortOption { recentlyAdded, titleAZ, releaseDate, watchedFirst, unwatchedFirst }

class WatchlistController extends GetxController {
  late Box<MovieItem> watchlistBox;
  var savedMovies = <MovieItem>[].obs;
  var activeFilter = VaultFilter.all.obs;
  var isArchiveMode = false.obs;
  var archiveMediaFilter = ArchiveMediaFilter.all.obs;
  var selectedIds = <int>[].obs;
  var searchQuery = ''.obs;

  bool get isSelectionMode => selectedIds.isNotEmpty;

  List<MovieItem> get selectedMovies => savedMovies
      .where((movie) => selectedIds.contains(movie.id))
      .toList();

  String get screenTitle {
    if (isSelectionMode) {
      return '${selectedIds.length} selected';
    }
    return isArchiveMode.value ? 'Archived' : 'My Private Vault';
  }

  List<MovieItem> get filteredMovies {
    var scopedItems = savedMovies
        .where((movie) => movie.isArchived == isArchiveMode.value)
        .toList();

    scopedItems = switch (archiveMediaFilter.value) {
      ArchiveMediaFilter.all => scopedItems,
      ArchiveMediaFilter.movies =>
        scopedItems.where((movie) => movie.mediaType != 'tv').toList(),
      ArchiveMediaFilter.series =>
        scopedItems.where((movie) => movie.mediaType == 'tv').toList(),
    };

    final filteredByStatus = switch (activeFilter.value) {
      VaultFilter.all => scopedItems,
      VaultFilter.watched =>
        scopedItems.where((movie) => movie.isWatched).toList(),
      VaultFilter.unwatched =>
        scopedItems.where((movie) => !movie.isWatched).toList(),
    };

    final query = searchQuery.value.trim().toLowerCase();
    final searchedItems = query.isEmpty
        ? filteredByStatus
        : filteredByStatus
            .where((movie) => movie.title.toLowerCase().contains(query))
            .toList();

    return _applySort(searchedItems);
  }

  List<MovieItem> _applySort(List<MovieItem> items) {
    final sorted = [...items];
    final settingsBox = Hive.box(AppConstants.settingsBox);
    final sortValue = settingsBox.get(
      AppConstants.vaultSortKey,
      defaultValue: 'recentlyAdded',
    ) as String;

    switch (sortValue) {
      case 'titleAZ':
        sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'releaseDate':
        sorted.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        break;
      case 'watchedFirst':
        sorted.sort((a, b) {
          if (a.isWatched == b.isWatched) return 0;
          return a.isWatched ? -1 : 1;
        });
        break;
      case 'unwatchedFirst':
        sorted.sort((a, b) {
          if (a.isWatched == b.isWatched) return 0;
          return a.isWatched ? 1 : -1;
        });
        break;
      case 'recentlyAdded':
      default:
        sorted.sort((a, b) {
          final aKey = a.key is int ? a.key as int : 0;
          final bKey = b.key is int ? b.key as int : 0;
          return bKey.compareTo(aKey);
        });
        break;
    }

    return sorted;
  }

  @override
  void onInit() {
    super.onInit();
    watchlistBox = Hive.box<MovieItem>('watchlist');
    final args = Get.arguments;
    if (args is Map && args['mode'] == 'archive') {
      isArchiveMode.value = true;
    }
    loadMovies();
  }

  void loadMovies() {
    savedMovies.assignAll(watchlistBox.values.toList());
    final visibleIds = filteredMovies.map((movie) => movie.id).toSet();
    selectedIds.removeWhere((id) => !visibleIds.contains(id));
  }

  void setFilter(VaultFilter filter) {
    activeFilter.value = filter;
    selectedIds.clear();
  }

  void toggleFilter(VaultFilter filter) {
    activeFilter.value =
        activeFilter.value == filter ? VaultFilter.all : filter;
    selectedIds.clear();
  }

  void setArchiveMediaFilter(ArchiveMediaFilter filter) {
    archiveMediaFilter.value = filter;
    selectedIds.clear();
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
    final visibleIds = filteredMovies.map((movie) => movie.id).toSet();
    selectedIds.removeWhere((id) => !visibleIds.contains(id));
  }

  void toggleSelection(MovieItem movie) {
    if (selectedIds.contains(movie.id)) {
      selectedIds.remove(movie.id);
    } else {
      selectedIds.add(movie.id);
    }
    selectedIds.refresh();
  }

  void clearSelection() {
    selectedIds.clear();
  }

  Future<void> deleteSelected() async {
    final moviesToDelete = savedMovies
        .where((movie) => selectedIds.contains(movie.id))
        .toList();

    if (moviesToDelete.isEmpty) return;

    final idsToDelete = moviesToDelete.map((movie) => movie.id).toList();
    await watchlistBox.deleteAll(idsToDelete);

    final removedCount = moviesToDelete.length;
    selectedIds.clear();
    loadMovies();

    AppSnackbar.show(
      'Removed',
      '$removedCount item${removedCount == 1 ? '' : 's'} removed from '
          '${isArchiveMode.value ? 'archive' : 'vault'}',
    );
  }

  void toggleWatched(MovieItem movie) async {
    movie.isWatched = !movie.isWatched;
    await movie.save();
    savedMovies.refresh();
  }

  void archiveMovie(MovieItem movie) {
    movie.isArchived = true;
    watchlistBox.put(movie.id, movie);
    loadMovies();
    AppSnackbar.show(
      'Archived',
      '${movie.title} moved to archive',
    );
  }

  void restoreMovie(MovieItem movie) {
    movie.isArchived = false;
    watchlistBox.put(movie.id, movie);
    loadMovies();
    AppSnackbar.show(
      'Restored',
      '${movie.title} moved back to your vault',
    );
  }

  void deleteMovie(MovieItem movie) {
    watchlistBox.delete(movie.id);
    loadMovies();
    AppSnackbar.show(
      'Removed',
      '${movie.title} removed from ${isArchiveMode.value ? 'archive' : 'vault'}',
    );
  }
}
