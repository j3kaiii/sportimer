part of 'sequence_screen_bloc.dart';

abstract class SequenceScreenState extends Equatable {
  const SequenceScreenState();
  
  @override
  List<Object> get props => [];
}

class SequenceScreenInitial extends SequenceScreenState {}

class SequenceScreenLoadSuccess extends SequenceScreenState {
  final String name;
  final List<TimerItem> data;
  final int repeats;
  const SequenceScreenLoadSuccess(this.name, this.data, {this.repeats = 0});

  @override
  List<Object> get props => [name, data, repeats];
}
