import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/watchlist_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/responsive_app_bar_title.dart';

class WatchlistView extends GetView<WatchlistController> {
  const WatchlistView({super.key});

  String _mediaFilterLabel(ArchiveMediaFilter filter) {
    return switch (filter) {
      ArchiveMediaFilter.all => 'All',
      ArchiveMediaFilter.movies => 'Movies',
      ArchiveMediaFilter.series => 'Series',
    };
  }

  Future<void> _showRemoveDialog() async {
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Remove selected items?'),
        content: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are removing ${controller.selectedIds.length} '
                'item${controller.selectedIds.length == 1 ? '' : 's'} from your '
                '${controller.isArchiveMode.value ? 'archive' : 'vault'}:',
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: SingleChildScrollView(
                  child: Column(
                    children: controller.selectedMovies
                        .map(
                          (movie) => CheckboxListTile(
                            value: true,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            onChanged: null,
                            title: Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      controller.deleteSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => ResponsiveAppBarTitle(controller.screenTitle)),
        leading: IconButton(
          icon: Icon(
            controller.isSelectionMode ? Icons.close : Icons.arrow_back,
          ),
          onPressed: () {
            if (controller.isSelectionMode) {
              controller.clearSelection();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          Obx(
            () => controller.isSelectionMode
                ? IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _showRemoveDialog,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        final movies = controller.filteredMovies;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                onChanged: controller.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: controller.isArchiveMode.value
                      ? 'Search archived movies or series'
                      : 'Search your private vault',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    PopupMenuButton<ArchiveMediaFilter>(
                      onSelected: controller.setArchiveMediaFilter,
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: ArchiveMediaFilter.all,
                          child: Text('All'),
                        ),
                        PopupMenuItem(
                          value: ArchiveMediaFilter.movies,
                          child: Text('Movies'),
                        ),
                        PopupMenuItem(
                          value: ArchiveMediaFilter.series,
                          child: Text('Series'),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check, size: 18),
                            const SizedBox(width: 8),
                            Text(_mediaFilterLabel(
                              controller.archiveMediaFilter.value,
                            )),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Watched'),
                      selected:
                          controller.activeFilter.value == VaultFilter.watched,
                      onSelected: (_) =>
                          controller.toggleFilter(VaultFilter.watched),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Unwatched'),
                      selected:
                          controller.activeFilter.value == VaultFilter.unwatched,
                      onSelected: (_) =>
                          controller.toggleFilter(VaultFilter.unwatched),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: movies.isEmpty
                  ? Center(
                      child: Text(
                        controller.searchQuery.value.isNotEmpty
                            ? 'No results found.'
                            : controller.isArchiveMode.value
                                ? 'Your archive is empty.'
                                : 'Your vault is empty.',
                      ),
                    )
                  : ListView.separated(
                      itemCount: movies.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final movieItem = movies[index];
                        final dynamic movieData = {
                          'id': movieItem.id,
                          'title': movieItem.title,
                          'poster_path': movieItem.posterPath,
                          'overview': movieItem.overview,
                          'release_date': movieItem.releaseDate,
                          'vote_average': movieItem.voteAverage,
                        };

                        final tile = ListTile(
                          key: ValueKey(
                            '${movieItem.id}-${controller.isSelectionMode}-${controller.selectedIds.contains(movieItem.id)}',
                          ),
                          selected: controller.selectedIds.contains(movieItem.id),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          tileColor: controller.selectedIds.contains(movieItem.id)
                              ? Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withOpacity(0.22)
                              : null,
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
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
                            ],
                          ),
                          title: Text(
                            movieItem.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            movieItem.isWatched ? 'Watched' : 'Unwatched',
                            style: TextStyle(
                              color: movieItem.isWatched ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Obx(() {
                            final isSelected =
                                controller.selectedIds.contains(movieItem.id);

                            if (controller.isSelectionMode) {
                              return Checkbox(
                                value: isSelected,
                                activeColor: Colors.deepPurpleAccent,
                                onChanged: (_) =>
                                    controller.toggleSelection(movieItem),
                              );
                            }

                            return IconButton(
                              key: ValueKey('eye-${movieItem.id}'),
                              icon: Icon(
                                movieItem.isWatched
                                    ? Icons.visibility
                                    : Icons.remove_red_eye_outlined,
                                color: movieItem.isWatched
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              onPressed: () =>
                                  controller.toggleWatched(movieItem),
                            );
                          }),
                          onTap: () {
                            if (controller.isSelectionMode) {
                              controller.toggleSelection(movieItem);
                            } else {
                              Get.toNamed(
                                Routes.DETAILS,
                                arguments: movieData,
                              );
                            }
                          },
                          onLongPress: () => controller.toggleSelection(movieItem),
                        );

                        if (controller.isArchiveMode.value) {
                          return Dismissible(
                            key: ValueKey('archive-${movieItem.id}'),
                            direction: controller.isSelectionMode
                                ? DismissDirection.none
                                : DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.teal,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.unarchive_outlined, color: Colors.white),
                                  SizedBox(height: 4),
                                  Text(
                                    'Restore',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            confirmDismiss: (_) async {
                              controller.restoreMovie(movieItem);
                              return false;
                            },
                            child: tile,
                          );
                        }

                        return Dismissible(
                          key: ValueKey(movieItem.id),
                          direction: controller.isSelectionMode
                              ? DismissDirection.none
                              : DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.blueGrey,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.archive_outlined, color: Colors.white),
                                SizedBox(height: 4),
                                Text(
                                  'Archive',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          confirmDismiss: (_) async {
                            controller.archiveMovie(movieItem);
                            return false;
                          },
                          child: tile,
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
