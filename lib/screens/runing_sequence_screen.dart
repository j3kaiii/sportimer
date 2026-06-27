import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/application/theme.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:sportimer/utils/context_extension.dart';
import 'package:sportimer/widgets/return_button.dart';

class RuningSequenceScreen extends StatefulWidget {
  final Sequence sequence;
  const RuningSequenceScreen({required this.sequence, super.key});

  @override
  State<RuningSequenceScreen> createState() => _RunningSequenceScreenState();
}

class _RunningSequenceScreenState extends State<RuningSequenceScreen> {
  final List<TimerItem> _timers = [];
  Timer? _currentTimer;

  final ValueNotifier<int> _currentTimerIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isRunning = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isCompleted = ValueNotifier<bool>(false);

  final AudioPlayer _countdownPlayer = AudioPlayer();
  bool _soundsLoaded = false;
  final ValueNotifier<int> _minutes = ValueNotifier<int>(0);
  final ValueNotifier<int> _seconds = ValueNotifier<int>(0);
  int _totalSeconds = 0;

  TimerData? _pausedData;

  @override
  void initState() {
    super.initState();
    _loadTimers();
  }

  Future<void> _initializeAudio() async {
    try {
      await _countdownPlayer.setAsset('assets/sounds/countdown.wav');
      await _countdownPlayer.setLoopMode(LoopMode.off);
      await _countdownPlayer.seek(Duration.zero);
      if (mounted) {
        setState(() {
          _soundsLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Ошибка загрузки звуков: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_soundsLoaded) _initializeAudio();
  }

  @override
  void dispose() {
    _currentTimer?.cancel();
    _countdownPlayer.dispose();
    _minutes.dispose();
    _seconds.dispose();
    _currentTimerIndex.dispose();
    _isRunning.dispose();
    _isCompleted.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SportimerThemeData.kBgDark,
              SportimerThemeData.kRunningBgEnd
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(t),
              Expanded(child: _buildCenter(context, t)),
              _buildBottom(context, t),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SportimerThemeData t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              ReturnButton(),
              Expanded(
                child: Center(
                  child:
                      Text(widget.sequence.name, style: t.runningSeqNameStyle),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<int>(
            valueListenable: _currentTimerIndex,
            builder: (ctx, idx, _) => Text(
              context.loc.timerByOrder(idx + 1, _timers.length),
              style: t.runningTimerInfoStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenter(BuildContext context, SportimerThemeData theme) {
    if (_timers.isEmpty) return const SizedBox.shrink();
    return ValueListenableBuilder<int>(
      valueListenable: _currentTimerIndex,
      builder: (ctx, idx, _) {
        final current = _timers[idx];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimerRing(theme),
            const SizedBox(height: 4),
            _buildDescription(context, theme, isRest: current.isRest),
            const SizedBox(height: 12),
            _buildDotsStrip(),
          ],
        );
      },
    );
  }

  Widget _buildDescription(BuildContext context, SportimerThemeData theme,
          {required bool isRest}) =>
      Text(
        isRest ? context.loc.isRestTitle : context.loc.isTrainingTitle,
        style: theme.runningTypeLabelStyle.copyWith(
          color: isRest
              ? SportimerThemeData.kAccentRestLight
              : SportimerThemeData.kAccentWorkoutLight,
        ),
      );

  Widget _buildTimerRing(SportimerThemeData t) {
    const size = 220.0;

    return ValueListenableBuilder<int>(
      valueListenable: _minutes,
      builder: (ctx, m, _) {
        return ValueListenableBuilder<int>(
          valueListenable: _seconds,
          builder: (ctx, s, _) {
            final remaining = m * 60 + s;
            final progress =
                _totalSeconds > 0 ? remaining / _totalSeconds : 0.0;
            final isRest = _timers[_currentTimerIndex.value].isRest;
            return SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(size, size),
                    painter: _RingPainter(progress: progress, isRest: isRest),
                  ),
                  Text(
                    '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
                    style: t.runningCountdownStyle,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDotsStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_timers.length, (index) {
        final isActive = index == _currentTimerIndex.value;
        final timer = _timers[index];
        final dotColor = timer.isRest
            ? SportimerThemeData.kAccentRest
            : SportimerThemeData.kAccentWorkout;
        return Container(
          width: isActive ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: dotColor,
          ),
        );
      }),
    );
  }

  Widget _buildBottom(BuildContext context, SportimerThemeData t) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
      height: 172,
      child: ListenableBuilder(
        listenable:
            Listenable.merge([_currentTimerIndex, _isCompleted, _isRunning]),
        builder: (ctx, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!_isCompleted.value &&
                  _currentTimerIndex.value < _timers.length - 1)
                _buildNextUp(context, t),
              if (_isCompleted.value)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => context.goNamed(root),
                    child: Text(
                      context.loc.completedMsg,
                      style: t.runningCountdownStyle.copyWith(fontSize: 24),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              _buildControls(context, t),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNextUp(BuildContext context, SportimerThemeData theme) {
    final nextIndex = _currentTimerIndex.value + 1;
    if (nextIndex >= _timers.length) return const SizedBox.shrink();
    final next = _timers[nextIndex];
    final nextM = next.seconds ~/ 60;
    final nextS = next.seconds % 60;
    final loc = context.loc;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(loc.nextUpTimer, style: theme.nextUpStyle),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: next.isRest
                  ? SportimerThemeData.kAccentRestSoft
                  : SportimerThemeData.kAccentWorkoutSoft,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              next.isRest ? loc.isRestTitle : loc.isTrainingTitle,
              style: theme.nextUpBadgeStyle.copyWith(
                color: next.isRest
                    ? SportimerThemeData.kAccentRestLight
                    : SportimerThemeData.kAccentWorkoutLight,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${nextM.toString().padLeft(2, '0')}:${nextS.toString().padLeft(2, '0')}',
            style: theme.nextUpStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, SportimerThemeData t) {
    return ListenableBuilder(
      listenable:
          Listenable.merge([_isRunning, _currentTimerIndex, _isCompleted]),
      builder: (ctx, _) {
        final showSmallBtns = _isRunning.value || _pausedData != null;
        final showMainBtn = (_currentTimerIndex.value == 0 &&
                !_isRunning.value &&
                _pausedData == null &&
                !_isCompleted.value) ||
            _isRunning.value ||
            _pausedData != null;

        if (!showMainBtn) return const SizedBox.shrink();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showSmallBtns)
              _SmallControlBtn(
                icon: '↺',
                isEnabled: true,
                onTap: _resetSequence,
              ),
            if (showSmallBtns) const SizedBox(width: 16),
            _MainControlBtn(
              icon: _mainIcon,
              isEnabled: _soundsLoaded,
              isLoading: !_soundsLoaded &&
                  _currentTimerIndex.value == 0 &&
                  _pausedData == null,
              onTap: _onMainAction,
            ),
            if (showSmallBtns) const SizedBox(width: 16),
            if (showSmallBtns)
              _SmallControlBtn(
                icon: '■',
                isEnabled: true,
                onTap: _stopSequence,
              ),
          ],
        );
      },
    );
  }

  String get _mainIcon {
    if (_currentTimerIndex.value == 0 &&
        !_isRunning.value &&
        _pausedData == null &&
        !_isCompleted.value) {
      return '▶';
    }
    if (_isRunning.value) return '❚❚';
    return '▶';
  }

  void _onMainAction() {
    if (_currentTimerIndex.value == 0 &&
        !_isRunning.value &&
        _pausedData == null &&
        !_isCompleted.value) {
      _startSequence();
    } else if (_isRunning.value) {
      _pauseSequence();
    } else if (_pausedData != null) {
      _resumeSequence();
    }
  }

  void _loadTimers() {
    final timerBox = Hive.box<TimerItem>(timersBoxName);
    _timers.addAll(
      timerBox.values.where((t) => t.sequenceId == widget.sequence.id),
    );
    _timers.sort((a, b) => a.position.compareTo(b.position));
  }

  Future<void> _startSequence() async {
    if (_timers.isEmpty || _isRunning.value || !_soundsLoaded) return;

    _playCountdown(isStart: true);
    await Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      _isRunning.value = true;
      _isCompleted.value = false;
      _startCurrentTimer();
    });
  }

  void _startCurrentTimer() {
    final currentTimerData = _timers[_currentTimerIndex.value];
    final mins = _pausedData?.min ?? currentTimerData.timerData.min;
    final secs = _pausedData?.sec ?? currentTimerData.timerData.sec;
    _totalSeconds = currentTimerData.seconds;
    _minutes.value = mins;
    _seconds.value = secs;
    _pausedData = null;

    _currentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds.value > 0) {
        _seconds.value--;
        if (_minutes.value == 0 && _seconds.value == 5) {
          _playCountdown(isStart: false);
        }
      } else if (_minutes.value > 0) {
        _minutes.value--;
        _seconds.value = 59;
      } else {
        _moveToNextTimer();
      }
    });
  }

  void _playCountdown({required bool isStart}) {
    try {
      final pos = isStart ? const Duration(seconds: 2) : Duration.zero;
      _countdownPlayer.seek(pos);
      _countdownPlayer.play();
    } catch (e) {
      // не найден звук, продолжаем работать
    }
  }

  void _moveToNextTimer() {
    _currentTimer?.cancel();
    if (_currentTimerIndex.value < _timers.length - 1) {
      _currentTimerIndex.value++;
      _startCurrentTimer();
    } else {
      _completeSequence();
    }
  }

  void _completeSequence() {
    _isRunning.value = false;
    _isCompleted.value = true;
  }

  void _pauseSequence() {
    _currentTimer?.cancel();
    _isRunning.value = false;
    _pausedData = TimerData(min: _minutes.value, sec: _seconds.value);
  }

  void _resumeSequence() {
    if (_pausedData != null && _soundsLoaded) {
      _startCurrentTimer();
      _isRunning.value = true;
    }
  }

  void _resetSequence() {
    _currentTimer?.cancel();
    _currentTimerIndex.value = 0;
    _isRunning.value = false;
    _isCompleted.value = false;
    _pausedData = null;
    _minutes.value = 0;
    _seconds.value = 0;
  }

  void _stopSequence() {
    _currentTimer?.cancel();
    _isRunning.value = false;
    _isCompleted.value = false;
    _pausedData = null;
    _currentTimerIndex.value = 0;
    _minutes.value = 0;
    _seconds.value = 0;
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final bool isRest;

  _RingPainter({required this.progress, required this.isRest});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 100.0;
    const strokeWidth = 6.0;

    final bgPaint = Paint()
      ..color = isRest
          ? SportimerThemeData.kRingBgRest
          : SportimerThemeData.kRingBgWorkout
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -pi / 2 + 2 * pi * (1 - progress);
    final sweepAngle = 2 * pi * progress;

    final gradientPaint = Paint()
      ..shader = (isRest
              ? SportimerThemeData.restGradient
              : SportimerThemeData.workoutGradient)
          .createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, gradientPaint);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _SmallControlBtn extends StatelessWidget {
  final String icon;
  final bool isEnabled;
  final VoidCallback onTap;

  const _SmallControlBtn({
    required this.icon,
    this.isEnabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SportimerThemeData.kBgCard,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Center(
          child: Text(
            icon,
            style: TextStyle(
              fontSize: 20,
              color: isEnabled
                  ? SportimerThemeData.kTextSecondary
                  : SportimerThemeData.kTextMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _MainControlBtn extends StatelessWidget {
  final String icon;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onTap;

  const _MainControlBtn({
    required this.icon,
    this.isEnabled = true,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SportimerThemeData.workoutGradient,
          boxShadow: [
            BoxShadow(
              color: SportimerThemeData.kAccentWorkout.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  icon,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
