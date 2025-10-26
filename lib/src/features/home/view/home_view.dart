import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_concert/src/dialogs/toast_wrapper.dart';
import 'package:mobile_concert/src/router/coordinator.dart';
import 'package:mobile_concert/src/router/route_name.dart';
import 'package:mobile_concert/widgets/button/text_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            XTextButton(
              title: 'Show Toast',
              onPressed: () {
                XToast.show('Clicked');
              },
            ),
            const XTextButton(
              title: 'Show sample view',
              onPressed: AppCoordinator.showSampleScreen,
            ),
          ],
        ),
      ),
    );
  }
}
