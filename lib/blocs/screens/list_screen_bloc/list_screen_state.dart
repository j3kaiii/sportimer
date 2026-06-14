part of 'list_screen_bloc.dart';


abstract class ListScreenState extends Equatable {
  const ListScreenState();

  @override
  List<Object?> get props => const [];
}

abstract class ListScreenSuccess extends ListScreenState {
  final  List<SequenceData> list;

  const ListScreenSuccess({required this.list});
}

class ListScreenBlocInitial extends ListScreenState {
  const ListScreenBlocInitial();
}

/// Данные загружены.
class ListScreenLoadSuccess extends ListScreenSuccess {
  const ListScreenLoadSuccess({required super.list});

  @override
  List<Object> get props => [list];
}

class ListScreenSequenceAdded extends ListScreenSuccess {
  final Sequence sequence;
  const ListScreenSequenceAdded(this.sequence, {required super.list});

  @override
  List<Object> get props => [sequence];
}
