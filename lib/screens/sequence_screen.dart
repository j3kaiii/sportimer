import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/application/localizations.dart';
import 'package:sportimer/application/theme.dart';
import 'package:sportimer/blocs/screens/list_screen_bloc/list_screen_bloc.dart';
import 'package:sportimer/blocs/screens/sequence_screen_bloc/sequence_screen_bloc.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:sportimer/utils/context_extension.dart';
import 'package:sportimer/widgets/edit_title_popup.dart';
import 'package:sportimer/widgets/edit_timer_popup.dart';
import 'package:sportimer/widgets/sequence_timer_tile.dart';
import 'package:sportimer/widgets/timer_popup.dart';

class SequenceScreen extends StatelessWidget {
  final Sequence sequence;
  const SequenceScreen({super.key, required this.sequence});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SequenceScreenBloc>(
      create: (context) => SequenceScreenBloc(
        sequenceBox: context.sequenceBox,
        timerBox: context.timersBox,
      )..add(SequenceScreenShownEvent(sequence)),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = context.theme;
    final loc = context.loc;
    return Scaffold(
      backgroundColor: theme.primaryBgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, theme),
            Expanded(child: _buildTimerList(context, theme, loc)),
            _buildStartButton(context, theme, loc),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SportimerThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.secondaryBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back, size: 18),
              color: theme.textSecondary,
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 12),
          _buildEditableTitle(context, theme),
        ],
      ),
    );
  }

  Widget _buildEditableTitle(BuildContext context, SportimerThemeData theme) {
    return BlocBuilder<SequenceScreenBloc, SequenceScreenState>(
        builder: (context, state) {
      if (state is SequenceScreenLoadSuccess) {
        return Expanded(
          child: GestureDetector(
            onTap: () => _showEditTitlePopup(context),
            child: Row(
              children: [
                _buildTitle(context, state.name, theme),
                const SizedBox(width: 6),
                Icon(Icons.edit, size: 16, color: theme.textMuted),
              ],
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildTitle(
    BuildContext context,
    String title,
    SportimerThemeData theme,
  ) {
    return Flexible(
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.titleTextStyle,
      ),
    );
  }

  Widget _buildTimerList(
    BuildContext context,
    SportimerThemeData theme,
    AppLocalizations loc,
  ) {
    return BlocBuilder<SequenceScreenBloc, SequenceScreenState>(
      builder: (context, state) {
        final addTimerButton = _buildAddTimerButton(context, theme, loc);
        if (state is SequenceScreenLoadSuccess) {
          final timers = state.data;
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 12),
            itemCount: timers.length + 1,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index == timers.length) {
                return addTimerButton;
              }
              final t = timers[index];
              return SequenceTimerTile(
                seconds: t.seconds,
                isRest: t.isRest,
                difficulty: t.isRest ? null : t.difficulty.name,
                onTap: () => _showEditTimerPopup(context, t),
              );
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildAddTimerButton(
    BuildContext context,
    SportimerThemeData theme,
    AppLocalizations loc,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _showAddTimerPopup(context),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: theme.borderColor,
            radius: 14,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18, color: theme.textMuted),
                const SizedBox(width: 8),
                Text(
                  loc.addTimer,
                  style: theme.cardMetaStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(
    BuildContext context,
    SportimerThemeData theme,
    AppLocalizations loc,
  ) {
    return BlocBuilder<SequenceScreenBloc, SequenceScreenState>(
      builder: (context, state) {
        final canRun =
            state is SequenceScreenLoadSuccess && state.data.isNotEmpty;
        final textColor = canRun ? theme.textPrimary : theme.textSecondary;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: theme.activeItemColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: canRun
                    ? () => context.goNamed(
                          runSequenceName,
                          extra: sequence,
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ).copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.disabled)) {
                      return theme.textMuted.withValues(alpha: 0.3);
                    }
                    return Colors.transparent;
                  }),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient:
                        canRun ? SportimerThemeData.workoutGradient : null,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, color: textColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          loc.btnStart.toUpperCase(),
                          style: canRun
                              ? theme.buttonTextStyle
                              : theme.buttonTextStyle
                                  .copyWith(color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddTimerPopup(BuildContext context) async {
    final result = await TimerPopup.show(context);

    if (!context.mounted) return;
    if (result == null) return;

    context.read<SequenceScreenBloc>().add(SequenceScreenTimerAddEvent(result));
    context.read<ListScreenBloc>().add(ListScreenUpdateEvent());
  }

  Future<void> _showEditTimerPopup(
    BuildContext context,
    TimerItem timer,
  ) async {
    final bloc = context.read<SequenceScreenBloc>();
    final state = bloc.state;
    if (state is! SequenceScreenLoadSuccess) return;
    final res = await showDialog<TimerData>(
      context: context,
      builder: (_) => EditTimerPopup(initialSeconds: timer.seconds),
    );
    if (res != null) {
      bloc.add(SequenceScreenTimerChangeEvent(
        TimerData(min: res.min, sec: res.sec, timerId: timer.id),
      ));
      if (context.mounted) {
        context.read<ListScreenBloc>().add(ListScreenUpdateEvent());
      }
    }
  }

  Future<void> _showEditTitlePopup(BuildContext context) async {
    final bloc = context.read<SequenceScreenBloc>();
    final state = bloc.state;
    if (state is! SequenceScreenLoadSuccess) return;

    final existingTitles =
        context.sequenceBox.values.map((s) => s.name).toList();
    final res = await showDialog<String>(
      context: context,
      builder: (_) =>
          EditTitlePopup(existingTitles: existingTitles, prevTitle: state.name),
    );
    if (res != null) {
      bloc.add(SequenceScreenTitleChangeEvent(res));
      if (context.mounted) {
        context.read<ListScreenBloc>().add(ListScreenUpdateEvent());
      }
    }
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + 6).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
