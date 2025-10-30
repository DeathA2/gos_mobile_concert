import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';
import 'package:mobile_concert/src/features/dashboard/logic/navigation_bar_item.dart';
import 'package:mobile_concert/src/features/dashboard/logic/dashboard_bloc.dart';

class XBottomNavigationBar extends StatelessWidget {
  const XBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, XNavigationBarItems>(
      builder: (context, state) {
        return FlashyTabBar(
          items: [
            FlashyTabBarItem(
              icon: Assets.svgs.icHome.svg(),
              title: Text("Home"),
            ),
            FlashyTabBarItem(
              icon: Assets.svgs.icMessenger.svg(),
              title: Text("Messenger"),
            ),
            FlashyTabBarItem(
              icon: Assets.svgs.icUserDefault.svg(),
              title: Text("Account"),
            ),
          ],
          height: 55,
          selectedIndex: state.index,
          onItemSelected: context.read<DashboardBloc>().onDestinationSelected,
        );
      },
    );
  }
}
