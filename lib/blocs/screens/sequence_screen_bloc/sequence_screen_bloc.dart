import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:sportimer/blocs/screens/list_screen_bloc/list_screen_bloc.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:sportimer/widgets/timer_popup.dart';

part 'sequence_screen_event.dart';
part 'sequence_screen_state.dart';

class SequenceScreenBloc
    extends Bloc<SequenceScreenEvent, SequenceScreenState> {
  final Box<Sequence> sequenceBox;
  final Box<TimerItem> timerBox;
  final ListScreenBloc listScreenBloc;

  late Sequence currentSequence;

  SequenceScreenBloc({
    required this.sequenceBox,
    required this.timerBox,
    required this.listScreenBloc,
  }) : super(SequenceScreenInitial()) {
    on<SequenceScreenShownEvent>(_mapScreenShownToState);
    on<SequenceScreenTitleChangeEvent>(_mapScreenTitleChangedToState);
    on<SequenceScreenTimerAddEvent>(_mapScreenTimerAddedToState);
    on<SequenceScreenTimerChangeEvent>(_mapScreenTimerChangedToState);
    on<SequenceScreenTimerDeleteEvent>(_mapScreenTimerDeletedToState);
  }

  Future<void> _mapScreenShownToState(
    SequenceScreenShownEvent event,
    Emitter<SequenceScreenState> emit,
  ) async {
    currentSequence = event.sequence;
    final list = getActualTimers();

    emit(SequenceScreenLoadSuccess(event.sequence.name, list));
  }

  Future<void> _mapScreenTitleChangedToState(
    SequenceScreenTitleChangeEvent event,
    Emitter<SequenceScreenState> emit,
  ) async {
    currentSequence = currentSequence.copyWith(event.title);
    await sequenceBox.put(currentSequence.id, currentSequence);

    final list = getActualTimers();

    emit(SequenceScreenLoadSuccess(currentSequence.name, list));
    listScreenBloc.add(ListScreenUpdateEvent());
  }

  Future<void> _mapScreenTimerAddedToState(
    SequenceScreenTimerAddEvent event,
    Emitter<SequenceScreenState> emit,
  ) async {
    final data = event.data;
    var list = getActualTimers();
    final timer = data.isRest
        ? TimerItem.createRest(
            data.seconds, list.length + 1, currentSequence.id)
        : TimerItem.createTraining(
            data.seconds, list.length + 1, currentSequence.id, data.difficulty);
    await timerBox.put(timer.id, timer);
    list = getActualTimers();
    emit(SequenceScreenLoadSuccess(currentSequence.name, list));
    listScreenBloc.add(ListScreenUpdateEvent());
  }

  Future<void> _mapScreenTimerChangedToState(
    SequenceScreenTimerChangeEvent event,
    Emitter<SequenceScreenState> emit,
  ) async {
    final timerId = event.data.timerId;
    if (timerId == null) return;
    final existing = timerBox.get(timerId);
    if (existing == null) return;
    final updated = existing.copyWith(
      seconds: event.data.toSeconds,
      isRest: event.data.isRest,
    );
    await timerBox.put(updated.id, updated);
    final list = getActualTimers();
    emit(SequenceScreenLoadSuccess(currentSequence.name, list));
    listScreenBloc.add(ListScreenUpdateEvent());
  }

  Future<void> _mapScreenTimerDeletedToState(
    SequenceScreenTimerDeleteEvent event,
    Emitter<SequenceScreenState> emit,
  ) async {
    await timerBox.delete(event.timer.id);
    final list = getActualTimers();
    emit(SequenceScreenLoadSuccess(currentSequence.name, list));
    listScreenBloc.add(ListScreenUpdateEvent());
  }

  List<TimerItem> getActualTimers() => timerBox.values
      .where((t) => t.sequenceId == currentSequence.id)
      .sortedBy<num>((t) => t.position);
}
