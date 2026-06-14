import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:uuid/v4.dart';

part 'list_screen_event.dart';
part 'list_screen_state.dart';

class ListScreenBloc extends Bloc<ListScreenEvent, ListScreenState> {
  final Box<Sequence> sequenceBox;
  final Box<TimerItem> timers;

  final data = <SequenceData>[];

  ListScreenBloc(this.sequenceBox, this.timers)
      : super(ListScreenBlocInitial()) {
    on<ListScreenShownEvent>(_mapScreenShownToState);
    on<ListScreenAddSequenceEvent>(_mapSequenceAddedToState);
  }

  Future<void> _mapScreenShownToState(
    ListScreenShownEvent event,
    Emitter<ListScreenState> emit,
  ) async {
    final list = sequenceBox.values.toList();
    data.addAll(list.map(
      (s) {
        final seqTimers =
            timers.values.where((t) => t.sequenceId == s.id).toList();
        return SequenceData(
          sequence: s,
          intervalsCount: seqTimers.length,
          totalDuration: seqTimers.fold(0, (v, e) => v + e.seconds),
          hasRest: seqTimers.any((t) => t.isRest),
          isCyclic: false,
          hasWorkout: seqTimers.any((t) => !t.isRest),
        );
      },
    ).toList());
    emit(ListScreenLoadSuccess(list: data));
  }

  Future<void> _mapSequenceAddedToState(
    ListScreenAddSequenceEvent event,
    Emitter<ListScreenState> emit,
  ) async {
    final sequence = Sequence(const UuidV4().generate(), event.seqName, sequenceBox.length + 1);
    await sequenceBox.put(sequence.id, sequence);
    data.add(SequenceData.createNew(sequence));
    emit(ListScreenSequenceAdded(sequence, list: data));
  }
}

class SequenceData {
  final Sequence sequence;
  final int intervalsCount;
  final int totalDuration;
  final bool hasRest;
  final bool isCyclic;
  final bool hasWorkout;

  SequenceData({
    required this.sequence,
    required this.intervalsCount,
    required this.totalDuration,
    required this.hasRest,
    required this.isCyclic,
    required this.hasWorkout,
  });

  factory SequenceData.createNew(Sequence sequence) => SequenceData(
        sequence: sequence,
        intervalsCount: 0,
        totalDuration: 0,
        hasRest: false,
        isCyclic: false,
        hasWorkout: false,
      );
}
