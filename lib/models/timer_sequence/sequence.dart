import 'package:hive/hive.dart';
import 'package:uuid/v4.dart';

part 'sequence.g.dart';

@HiveType(typeId: 1)
class Sequence extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;

  Sequence(this.name) : id = const UuidV4().generate();
}
