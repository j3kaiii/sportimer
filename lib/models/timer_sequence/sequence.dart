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

  Sequence(this.id, this.name, this.position);

  Sequence copyWith(String updated) => Sequence(id, updated, position);

  @override
  String toString() => 'Sequence id: $id, name: $name, position: $position';
}
