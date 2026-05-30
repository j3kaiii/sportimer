import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/application/localizations.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:sportimer/utils/context_extension.dart';

class RuningSequenceScreen extends StatefulWidget {
  final Sequence sequence;
  const RuningSequenceScreen({required this.sequence, super.key});

  @override
  State<RuningSequenceScreen> createState() => _RunningSequenceScreenState();
}

class _RunningSequenceScreenState extends State<RuningSequenceScreen> {
  static const _style = TextStyle(
    fontSize: 200,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  final List<TimerItem> _timers = [];
  Timer? _currentTimer;

  int _currentTimerIndex = 0;
  bool _isRunning = false;
  bool _isCompleted = false;

  final AudioPlayer _countdownPlayer = AudioPlayer();
  bool _soundsLoaded = false;
  final ValueNotifier<int> _minutes = ValueNotifier<int>(0);
  final ValueNotifier<int> _seconds = ValueNotifier<int>(0);

  TimerData? _pausedData;

  bool get _isLandscape {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.orientation == Orientation.landscape;
  }

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

      setState(() {
        _soundsLoaded = true;
      });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sequence.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        _buildTimer(context),
        _buildControls(context, context.loc),
      ],
    );
  }

  Widget _buildTimer(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  _buildMinutes(context),
                  Text(delimeter, style: _style),
                  _buildSeconds(context),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildMinutes(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _minutes,
      builder: (ctx, v, _) => Text(
        v.toString().padLeft(2, '0'),
        style: _style,
      ),
    );
  }

  Widget _buildSeconds(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _seconds,
      builder: (ctx, v, _) => Text(
        v.toString().padLeft(2, '0'),
        style: _style,
      ),
    );
  }

  Widget _buildControls(BuildContext context, AppLocalizations loc) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: _isLandscape
          ? _buildLandscape(context, loc)
          : _buildPortrait(context, loc),
    );
  }

  Widget _buildPortrait(BuildContext context, AppLocalizations loc) {
    return Column(
      children: [
        Text(
          _timerByOrder(loc),
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        _buildControlButtons(context, loc),
        const SizedBox(height: 20),
        if (_isCompleted)
          Text(
            loc.completedMsg,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
      ],
    );
  }

  Widget _buildLandscape(BuildContext context, AppLocalizations loc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _timerByOrder(loc),
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
        _buildControlButtons(context, loc),
        if (_isCompleted)
          Expanded(
            child: Text(
              loc.completedMsg,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildControlButtons(BuildContext context, AppLocalizations loc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!_isRunning && !_isCompleted && _currentTimerIndex == 0)
          ElevatedButton(
            onPressed: _soundsLoaded ? _startSequence : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: _soundsLoaded
                ? Text(loc.btnStart)
                : const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
          ),
        if (_isRunning)
          ElevatedButton(
            onPressed: _pauseSequence,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(loc.btnPause),
          ),
        if (!_isRunning && _currentTimerIndex > 0 && !_isCompleted)
          ElevatedButton(
            onPressed: _resumeSequence,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(loc.btnResume),
          ),
        if (_currentTimerIndex > 0 || _isCompleted) const SizedBox(width: 20),
        if (_currentTimerIndex > 0 || _isCompleted)
          ElevatedButton(
            onPressed: _resetSequence,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(loc.btnReset),
          ),
      ],
    );
  }

  void _loadTimers() {
    final timerBox = Hive.box<TimerItem>(timersBoxName);
    _timers.addAll(
        timerBox.values.where((t) => t.sequenceId == widget.sequence.id));
    _timers.sort((a, b) => a.position.compareTo(b.position));
  }

  Future<void> _startSequence() async {
    if (_timers.isEmpty || _isRunning || !_soundsLoaded) return;

    _playCountdown(isStart: true);
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isRunning = true;
        _isCompleted = false;
      });
      _startCurrentTimer();
    });
  }

  void _startCurrentTimer() {
    final currentTimerData = _timers[_currentTimerIndex];
    _minutes.value = _pausedData?.min ?? currentTimerData.timerData.min;
    _seconds.value = _pausedData?.sec ?? currentTimerData.timerData.sec;

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
      final pos = isStart ? Duration(seconds: 2) : Duration.zero;
      _countdownPlayer.seek(pos);
      _countdownPlayer.play();
    } catch (e) {
      // не найден звук, продолжаем работать
    }
  }

  void _moveToNextTimer() {
    _currentTimer?.cancel();

    if (_currentTimerIndex < _timers.length - 1) {
      _currentTimerIndex++;

      _startCurrentTimer();
    } else {
      _completeSequence();
    }
  }

  void _completeSequence() {
    setState(() {
      _isRunning = false;
      _isCompleted = true;
    });
  }

  void _pauseSequence() {
    _currentTimer?.cancel();
    setState(() {
      _isRunning = false;
      _pausedData = TimerData(min: _minutes.value, sec: _seconds.value);
    });
  }

  void _resumeSequence() {
    if (!_isRunning && !_isCompleted && _soundsLoaded) {
      _startCurrentTimer();
      setState(() {
        _isRunning = true;
      });
    }
  }

  void _resetSequence() {
    _currentTimer?.cancel();
    setState(() {
      _currentTimerIndex = 0;
      _isRunning = false;
      _isCompleted = false;
    });
  }

  String _timerByOrder(AppLocalizations loc) =>
      loc.timerByOrder(_currentTimerIndex + 1, _timers.length);
}
