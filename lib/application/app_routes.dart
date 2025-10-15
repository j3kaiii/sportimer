import 'package:go_router/go_router.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/screens/lists_screen.dart';
import 'package:sportimer/screens/loading_screen.dart';

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
      // routes: [
      //   GoRoute(
      //     path: shoppingPath,
      //     name: shoppingName,
      //     builder: (context, state) => ShoppingScreen(
      //       shopping: state.extra as ShoppingList,
      //     ),
      //     routes: [
      //       GoRoute(
      //         path: productsPath,
      //         name: products,
      //         builder: (context, state) => ProductsScreen(
      //           shoppingBox: state.extra as Box<Item>,
      //         ),
      //       )
      //     ],
      //   )
      // ],
    ),
  ],
);
