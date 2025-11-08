import 'package:go_router/go_router.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:sportimer/screens/lists_screen.dart';
import 'package:sportimer/screens/loading_screen.dart';
import 'package:sportimer/screens/runing_sequence_screen.dart';
import 'package:sportimer/screens/sequence_screen.dart';

final appRoutes = GoRouter(
  initialLocation: loading,
  routes: [
    GoRoute(
      path: loading,
      name: loading,
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: root,
      name: root,
      builder: (context, state) => const ListsScreen(),
      routes: [
        GoRoute(
          path: sequencePath,
          name: sequenceName,
          builder: (context, state) => SequenceScreen(
            sequence: state.extra as Sequence,
          ),
          routes: [
            GoRoute(
              path: runSequencePath,
              name: runSequenceName,
              builder: (context, state) => RuningSequenceScreen(
                sequence: state.extra as Sequence,
              ),
            )
          ],
        )
      ],
    ),
  ],
);
