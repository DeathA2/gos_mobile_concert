import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_concert/src/network/data/post/post_repository_impl.dart';
import 'package:mobile_concert/src/network/data/user/user_repository_impl.dart';
import 'package:mobile_concert/src/network/model/post.dart';
import 'package:mobile_concert/src/network/model/user.dart';
import 'package:mobile_concert/src/store/app_store.dart';
import 'package:mobile_concert/src/utils/generate_user_sig.dart';
import 'package:tencent_live_uikit/common/index.dart';
import 'package:tencent_live_uikit/tencent_live_uikit.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState()) {
    _syncData();
    _login();
  }
  final userRepo = UserRepositoryImpl();
  final postRepo = PostRepositoryImpl();
  final _userId = 'philip_2';

  Future<void> _syncData() async {
    await _getListUser();
    _getListPost();
  }

  void _login() async {
    // _isButtonEnabled = false;
    print(
      "GenerateUserSig.genTestSig(_userId) ${GenerateUserSig.genTestSig(_userId)}",
    );

    await TUILogin.instance.login(
      GenerateUserSig.sdkAppId,
      _userId,
      GenerateUserSig.genTestSig(_userId),
      TUICallback(
        onError: (code, message) {
          LiveKitLogger.error(
            "TUILogin login fail, {code:$code, message:$message}",
          );
          makeToast(msg: "code:$code message:$message");
        },
        onSuccess: () async {
          LiveKitLogger.info("TUILogin login success");
          AppStore.userId = _userId;
          // Set default values if empty
          if (AppStore.userName.value.isEmpty) {
            AppStore.userName.value = "User $_userId";
          }
          if (AppStore.userAvatar.isEmpty) {
            AppStore.userAvatar = AppStore.defaultAvatar;
          }
          emit(state.copyWith(isLoggedIn: true));
          //await AppManager.getUserInfo(_userId);
          if (AppStore.userName.value.isEmpty || AppStore.userAvatar.isEmpty) {
            //_enterProfileWidget();
          } else {
            //_enterMainWidget();
          }
        },
      ),
    );
    //_isButtonEnabled = true;
  }

  Future<void> _getListUser() async {
    final listUser = await userRepo.getAllUser();
    emit(state.copyWith(listUser: listUser.data ?? []));
  }

  Future<void> _getListPost() async {
    final listPost = await postRepo.getAllPosts();
    final newPost = listPost.data?.map((post) {
      final ownerUser = state.listUser.firstWhere(
        (user) => user.id == post.owner,
        orElse: () => MUser(id: '', name: 'Unknown', avatar: ''),
      );
      return post.copyWith(ownerUser: ownerUser);
    }).toList();
    emit(state.copyWith(listPost: newPost ?? []));
  }
}
