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
                const SizedBox(height: 40),
                Image.asset('assets/images/app_icon.png'),
                const SizedBox(height: 30),
                Text(
                  loc.loadingTagline,
                  style: theme.taglineStyle,
                ),
                const SizedBox(height: 10),
                const _LoadingDots(),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
      duration: const Duration(seconds: 2),
    );
    _controller.addStatusListener(_onAnimStatusChanged);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onAnimStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
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

   void _onAnimStatusChanged(AnimationStatus s) {
    print('testdata status $s');
    if (s == AnimationStatus.completed && context.mounted) {
      context.goNamed(root);
    }
  }
}
