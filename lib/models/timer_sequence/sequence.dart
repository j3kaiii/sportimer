import 'package:hive/hive.dart';

part 'sequence.g.dart';

@HiveType(typeId: 1)
class Sequence extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;

  Sequence(this.id, this.name);

  Sequence copyWith(String updated) => Sequence(id, updated);

  @override
  String toString() => 'Sequence id: $id, name: $name,';
}
