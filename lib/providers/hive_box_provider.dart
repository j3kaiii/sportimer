// providers/hive_provider.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';

class HiveBoxProvider extends InheritedWidget {
  final Box<Sequence> sequenceBox;
  final Box<TimerItem> timersBox;

  const HiveBoxProvider({
    super.key,
    required super.child,
    required this.sequenceBox,
    required this.timersBox,
  });

  static HiveBoxProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<HiveBoxProvider>();
    assert(result != null, 'No HiveBoxProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(HiveBoxProvider oldWidget) {
    return sequenceBox != oldWidget.sequenceBox ||
        timersBox != oldWidget.timersBox;
  }
}
