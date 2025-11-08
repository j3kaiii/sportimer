import 'package:hive/hive.dart';
import 'package:uuid/v4.dart';

part 'timer_item.g.dart';

@HiveType(typeId: 0)
class TimerItem extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int seconds;
  @HiveField(2)
  final int position;
  @HiveField(3)
  final String sequenceId;

  TimerItem(
      {required this.id,
      required this.seconds,
      required this.position,
      required this.sequenceId});

  // Hive не дает сохранять один объект в разные боксы, нужна копия
  static TimerItem copy(TimerItem item) => TimerItem(
        id: const UuidV4().generate(),
        seconds: item.seconds,
        position: item.position,
        sequenceId: item.sequenceId,
      );

  factory TimerItem.create(int seconds, int position, String sequenceId) {
    final id = const UuidV4().generate();
    return TimerItem(
      id: id,
      seconds: seconds,
      position: position,
      sequenceId: sequenceId,
    );
  }

  @override
  String toString() =>
      'TimerItem $id, seconds: $seconds, position: $position, sequenceId: $sequenceId';

  String displayAsTime() {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  TimerData get timerData => TimerData(min: seconds ~/ 60, sec: seconds % 60);
}

class TimerData {
  static const _secondsPerMin = 60;
  final int min;
  final int sec;

  TimerData({required this.min, required this.sec});

  int get toSeconds => min * _secondsPerMin + sec;
}
