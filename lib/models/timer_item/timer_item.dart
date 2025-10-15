import 'package:hive/hive.dart';
import 'package:uuid/v4.dart';

part 'timer_item.g.dart';

@HiveType(typeId: 0)
class TimerItem extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int seconds;

  TimerItem({required this.id, required this.seconds});

  // Hive не дает сохранять один объект в разные боксы, нужна копия
  static TimerItem copy(TimerItem item) => TimerItem(
        id: const UuidV4().generate(),
        seconds: item.seconds,
      );

  factory TimerItem.create(int seconds) {
    final id = const UuidV4().generate();
    return TimerItem(id: id, seconds: seconds);
  }

  @override
  String toString() => 'TimerItem $id, seconds: $seconds';
}
