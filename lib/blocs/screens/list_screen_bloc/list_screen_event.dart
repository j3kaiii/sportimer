part of 'list_screen_bloc.dart';

abstract class ListScreenEvent extends Equatable {
  const ListScreenEvent();

  @override
  List<Object?> get props => const [];
}

/// Экран показан.
class ListScreenShownEvent extends ListScreenEvent {
  const ListScreenShownEvent();
}

/// Данные в боксе обновлены.
class ListScreenUpdateEvent extends ListScreenEvent {
  const ListScreenUpdateEvent();
}

/// Нажата кнопка добавления секвенса в бокс.
class ListScreenAddSequenceEvent extends ListScreenEvent {
  final String seqName;
  const ListScreenAddSequenceEvent(this.seqName);

  @override
  List<Object> get props => [seqName];
}
