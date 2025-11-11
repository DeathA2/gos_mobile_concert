import 'package:mobile_concert/src/router/route_name.dart';

enum XNavigationBarItems {
  home(
    route: AppRouteNames.home,
    icon: "assets/svgs/ic_home.svg",
    selectedIcon: "assets/svgs/ic_home_active.svg",
  ),
  search(
    route: AppRouteNames.home,
    icon: "assets/svgs/ic_search.svg",
    selectedIcon: "assets/svgs/ic_search.svg",
  ),
  create(
    route: AppRouteNames.videoLive,
    icon: "assets/svgs/ic_create.svg",
    selectedIcon: "assets/svgs/ic_create.svg",
  ),
  reel(
    route: AppRouteNames.home,
    icon: "assets/svgs/ic_reels.svg",
    selectedIcon: "assets/svgs/ic_reels.svg",
  ),
  account(
    route: AppRouteNames.account,
    icon: "assets/svgs/ic_favourite.svg",
    selectedIcon: "assets/svgs/ic_favourite_active.svg",
  );

  const XNavigationBarItems({
    required this.route,
    required this.icon,
    required this.selectedIcon,
  });

  final AppRouteNames route;
  final String icon;
  final String selectedIcon;

  static XNavigationBarItems fromLocation(String location) {
    if (location == XNavigationBarItems.home.route.name) {
      return XNavigationBarItems.home;
    }

    return XNavigationBarItems.home;
  }
}
