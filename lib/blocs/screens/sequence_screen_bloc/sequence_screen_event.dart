part of 'sequence_screen_bloc.dart';

abstract class SequenceScreenEvent extends Equatable {
  const SequenceScreenEvent();

  @override
  List<Object> get props => [];
}

class SequenceScreenShownEvent extends SequenceScreenEvent {
  final Sequence sequence;
  const SequenceScreenShownEvent(this.sequence);

  @override
  List<Object> get props => [sequence];
}

class SequenceScreenTitleChangeEvent extends SequenceScreenEvent {
  final String title;

  const SequenceScreenTitleChangeEvent(this.title);

  @override
  List<Object> get props => [title];
}

class SequenceScreenTimerAddEvent extends SequenceScreenEvent {
  final TimerAddResult data;

  const SequenceScreenTimerAddEvent(this.data);

  @override
  List<Object> get props => [data];
}

class SequenceScreenTimerChangeEvent extends SequenceScreenEvent {
  final TimerData data;

  const SequenceScreenTimerChangeEvent(this.data);

  @override
  List<Object> get props => [data];
}

class SequenceScreenTimerDeleteEvent extends SequenceScreenEvent {
  final TimerItem timer;

  const SequenceScreenTimerDeleteEvent(this.timer);

  @override
  List<Object> get props => [timer];
}

class SequenceScreenRepeatsChangeEvent extends SequenceScreenEvent {
  final int repeats;

  const SequenceScreenRepeatsChangeEvent(this.repeats);

  @override
  List<Object> get props => [repeats];
}
