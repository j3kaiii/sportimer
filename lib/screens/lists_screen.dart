import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/application/localizations.dart';
import 'package:sportimer/application/theme.dart';
import 'package:sportimer/blocs/screens/list_screen_bloc/list_screen_bloc.dart';
import 'package:sportimer/utils/context_extension.dart';
import 'package:sportimer/widgets/list_item.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.primaryBgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, loc, theme),
            Expanded(child: _buildList(context, loc, theme)),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(context, loc, theme),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    AppLocalizations loc,
    SportimerThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Text(
        loc.timerListTitle,
        style: theme.titleTextStyle,
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    AppLocalizations loc,
    SportimerThemeData theme,
  ) {
    const size = 56.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: SportimerThemeData.workoutGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.activeItemColor.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _addSequence(context, loc),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

Widget _buildList(
  BuildContext context,
  AppLocalizations loc,
  SportimerThemeData theme,
) {
  return BlocConsumer<ListScreenBloc, ListScreenState>(
      listener: (context, state) {
    if (state is ListScreenSequenceAdded) {
      context.goNamed(sequenceName, extra: state.sequence);
    }
  },
      builder: (context, state) {
    if (state is ListScreenSuccess) {
      final list = state.list;
      if (list.isEmpty) {
        return Center(
            child: Text(
          loc.listIsEmpty,
          style: theme.cardMetaStyle,
        ));
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final seq = list[index];
          return ListItem(
            name: seq.sequence.name,
            intervalsCount: seq.intervalsCount,
            totalDuration: seq.totalDuration.toString(),
            isCyclic: seq.isCyclic,
            hasWorkout: seq.hasWorkout,
            hasRest: seq.hasRest,
            onTap: () => context.goNamed(sequenceName, extra: seq.sequence),
          );
        },
      );
    }
    return CircularProgressIndicator();
  });
}

Future<void> _addSequence(
  BuildContext context,
  AppLocalizations loc,
) async {
  final bloc = context.read<ListScreenBloc>();
  final currentState = bloc.state;
  if (currentState is ListScreenLoadSuccess) {
    final nextName = loc.orderedName(currentState.list.length + 1);
    bloc.add(ListScreenAddSequenceEvent(nextName));
  }
}
