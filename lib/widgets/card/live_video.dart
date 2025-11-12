import 'package:flutter/material.dart';
import 'package:mobile_concert/src/config/env/env.dart';
import 'package:mobile_concert/src/services/tencent_cloud_service.dart';
import 'package:mobile_concert/src/utils/app_store.dart';
import 'package:mobile_concert/src/utils/generate_user_sig.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';

class LiveVideoCustom extends StatefulWidget {
  const LiveVideoCustom({super.key});

  @override
  State<LiveVideoCustom> createState() => _LiveVideoCustomState();
}

class _LiveVideoCustomState extends State<LiveVideoCustom> {
  final liveService = TencentLiveCloudService();

  @override
  void initState() {
    _initStreamData();

    super.initState();
  }

  @override
  void dispose() {
    liveService.exitRoom();
    super.dispose();
  }

  Future<void> _initStreamData() async {
    await liveService.enterRoom(
      sdkAppId: ENV.I.sdkAppId,
      userId: AppStore.userId,
      userSig: GenerateUserSig.genTestSig(AppStore.userId),
      roomId: 1001,
      role: TRTCCloudDef.TRTCRoleAudience,
      scene: TRTCCloudDef.TRTC_APP_SCENE_LIVE,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: TRTCCloudVideoView(
        onViewCreated: (viewId) {
          liveService.startRemoteStream(userId: "philip", viewId: viewId);
        },
      ),
    );
  }
}
