// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieItemAdapter extends TypeAdapter<MovieItem> {
  @override
  final int typeId = 0;

  @override
  MovieItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieItem(
      id: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String,
      overview: fields[3] as String,
      releaseDate: fields[4] as String,
      voteAverage: fields[5] as dynamic,
      isWatched: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MovieItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.overview)
      ..writeByte(4)
      ..write(obj.releaseDate)
      ..writeByte(5)
      ..write(obj.voteAverage)
      ..writeByte(6)
      ..write(obj.isWatched);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
