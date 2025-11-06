import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_concert/src/features/dashboard/logic/navigation_bar_item.dart';
import 'package:mobile_concert/src/features/dashboard/logic/dashboard_bloc.dart';

class XBottomNavigationBar extends StatelessWidget {
  const XBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, XNavigationBarItems>(
      builder: (context, state) {
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: state.index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.white,
          unselectedFontSize: 12,
          unselectedLabelStyle: const TextStyle(),
          selectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          onTap: context.read<DashboardBloc>().onDestinationSelected,
          items: XNavigationBarItems.values.map((e) {
            return BottomNavigationBarItem(
              label: "",
              activeIcon: SvgPicture.asset(
                e.selectedIcon,
                width: 24,
                height: 24,
              ),
              icon: SvgPicture.asset(e.icon, width: 24, height: 24),
            );
          }).toList(),
        );
      },
    );
  }
}
