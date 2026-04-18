import 'package:hive/hive.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
// Adding 'extends HiveObject' fixes the .save() and .delete() errors
class MovieItem extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final String overview;

  @HiveField(4)
  final String releaseDate;

  @HiveField(5)
  final dynamic voteAverage;

  @HiveField(6)
  bool isWatched; // Field for your "Eye" function status

  MovieItem({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    this.isWatched = false,
  });
}