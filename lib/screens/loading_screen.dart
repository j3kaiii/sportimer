import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/application/theme.dart';
import 'package:sportimer/utils/context_extension.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final loc = context.loc;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          context.goNamed(root);
        }
      });
    });
    return Material(
      child: GestureDetector(
        onTap: () => context.goNamed(root),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.5, -1.0),
              end: Alignment(0.5, 1.0),
              colors: [
                SportimerThemeData.kBgDark,
                SportimerThemeData.kBgCard,
                SportimerThemeData.kBgDark,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LogoWidget(),
                const SizedBox(height: 24),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      SportimerThemeData.kTextPrimary,
                      SportimerThemeData.kTextSecondary,
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    loc.applicationName,
                    style: theme.loadingTitleStyle,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Создай свой таймер',
                  style: theme.taglineStyle,
                ),
                const SizedBox(height: 48),
                const _LoadingDots(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  const _LogoWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: SportimerThemeData.workoutGradient,
        boxShadow: [
          BoxShadow(
            color: SportimerThemeData.kAccentWorkout.withValues(alpha: 0.3),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CustomPaint(
            painter: _TimerIconPainter(),
          ),
        ),
      ),
    );
  }
}

class _TimerIconPainter extends CustomPainter {
  const _TimerIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    paint.strokeWidth = 3.0;
    canvas.drawCircle(const Offset(24, 24), 18, paint);

    paint.strokeWidth = 2.5;
    canvas.drawLine(
      const Offset(24, 24),
      const Offset(24, 12),
      paint,
    );

    paint.strokeWidth = 2.0;
    canvas.drawLine(
      const Offset(24, 24),
      const Offset(34, 24),
      paint,
    );

    paint.style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(24, 24), 2.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final rawTime = _controller.value * 1.4 - index * 0.2;
            final effTime = ((rawTime % 1.4) + 1.4) % 1.4;
            final t = effTime / 1.4;
            double scale;
            double opacity;
            if (t < 0.4) {
              final progress = t / 0.4;
              scale = 0.8 + 0.2 * progress;
              opacity = 0.3 + 0.7 * progress;
            } else if (t < 0.8) {
              final progress = (t - 0.4) / 0.4;
              scale = 1.0 - 0.2 * progress;
              opacity = 1.0 - 0.7 * progress;
            } else {
              scale = 0.8;
              opacity = 0.3;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: SportimerThemeData.kAccentWorkout,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
