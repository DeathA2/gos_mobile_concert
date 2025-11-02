import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_concert/src/features/common/view/not_found_view.dart';
import 'package:mobile_concert/src/features/dashboard/logic/navigation_bar_item.dart';
import 'package:mobile_concert/src/features/dashboard/view/dashboard_view.dart';
import 'package:mobile_concert/src/features/home/view/home_view.dart';
import 'package:mobile_concert/src/features/photo_view/photo_view_page.dart';
import 'package:mobile_concert/src/router/coordinator.dart';
import 'package:mobile_concert/src/router/extras/photo_view_extra.dart';
import 'package:mobile_concert/src/router/route_name.dart';

class AppRouter {
  late final router = GoRouter(
    navigatorKey: AppCoordinator.navigatorKey,
    initialLocation: AppRouteNames.home.path,
    debugLogDiagnostics: kDebugMode,
    observers: [BotToastNavigatorObserver()],
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: AppCoordinator.shellKey,
        builder: (context, state, child) => DashBoardScreen(
          currentItem: XNavigationBarItems.fromLocation(state.uri.toString()),
          body: child,
        ),
        routes: <RouteBase>[
          GoRoute(
            path: AppRouteNames.home.path,
            name: AppRouteNames.home.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeView()),
            routes: <RouteBase>[
              // GoRoute(
              //   parentNavigatorKey: AppCoordinator.navigatorKey,
              //   path: AppRouteNames.sample.subPath,
              //   name: AppRouteNames.sample.name,
              //   builder: (_, __) => const SampleItemListView(),
              //   routes: <RouteBase>[
              //     GoRoute(
              //       parentNavigatorKey: AppCoordinator.navigatorKey,
              //       path: AppRouteNames.sampleDetails.buildSubPathParam,
              //       name: AppRouteNames.sampleDetails.name,
              //       builder: (_, state) {
              //         final id =
              //             state.pathParameters[AppRouteNames
              //                 .sampleDetails
              //                 .paramName]!;
              //         return SampleItemDetailsView(id: id);
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: AppCoordinator.navigatorKey,
        path: AppRouteNames.photoView.path,
        name: AppRouteNames.photoView.name,
        builder: (_, state) {
          PhotoViewExtra extra = state.extra as PhotoViewExtra;
          return PhotoViewPage(
            galleryItems: extra.galleryItems,
            initialIndex: extra.initialIndex,
            postInfor: extra.infor,
          );
        },
      ),
    ],
    errorBuilder: (_, __) => const NotFoundView(),
  );
}
