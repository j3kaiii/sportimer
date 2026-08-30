import 'package:hive/hive.dart';

part 'sequence.g.dart';

@HiveType(typeId: 1)
class Sequence extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int position;
  @HiveField(3)
  int repeats;

  Sequence(this.id, this.name, this.position, {this.repeats = 1});

  Sequence copyWith({String? name, int? repeats}) => Sequence(
        id,
        name ?? this.name,
        position,
        repeats: repeats ?? this.repeats,
      );

  @override
  String toString() =>
      'Sequence id: $id, name: $name, position: $position, repeats: $repeats';
}
