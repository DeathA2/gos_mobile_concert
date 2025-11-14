import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_concert/src/router/coordinator.dart';
import 'package:mobile_concert/src/services/firestore_service.dart';
import 'navigation_bar_item.dart';
import 'package:mobile_concert/src/dialogs/alert_wrapper.dart';
import 'package:mobile_concert/src/services/remote_config/remote_config_service.dart';

class DashboardBloc extends Cubit<XNavigationBarItems> {
  DashboardBloc(super.current) {
    checkForceUpdate();
  }

  bool checkForceUpdate() {
    final needForceUpdate = RemoteConfigService.config.needForceUpdate;
    if (needForceUpdate) {
      XAlert.showForceUpdate();
      return true;
    }
    return false;
  }

  void onDestinationSelected(int index) {
    emit(XNavigationBarItems.values[index]);
    // final postService = PostService();

    // postService.addPost(
    //   id: 94,
    //   content: "THE EN.....",
    //   mediaUrl: "https://www.dropbox.com/s/xxx/video.mp4?raw=1",
    //   owner: "lance",
    //   streamHostId: "philip_3",
    //   streamRoom: 1003,
    // );
    AppCoordinator.goNamed(state.route.name);
  }

  void goHome() {
    emit(XNavigationBarItems.home);
    AppCoordinator.goNamed(state.route.name);
  }
}
