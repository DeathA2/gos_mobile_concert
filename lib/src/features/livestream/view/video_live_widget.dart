import 'package:flutter/material.dart';
import 'package:live_stream_core/live_core_widget/live_core_widget.dart';
import 'package:mobile_concert/src/config/env/env.dart';
import 'package:mobile_concert/src/services/tencent_cloud_service.dart';
import 'package:mobile_concert/src/utils/app_store.dart';
import 'package:mobile_concert/src/utils/generate_user_sig.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';

class VideoLiveWidget extends StatefulWidget {
  const VideoLiveWidget({super.key});

  @override
  State<VideoLiveWidget> createState() => _VideoLiveWidgetState();
}

class _VideoLiveWidgetState extends State<VideoLiveWidget> {
  final enterRoomSuccessNotifier = ValueNotifier<bool>(false);
  String currentRoomId = '';
  bool _isInitializing = false;

  final controller = LiveCoreController();
  final liveService = TencentLiveCloudService();

  @override
  void initState() {
    super.initState();
    _initializeTencentLive();
  }

  Future<void> _initializeTencentLive() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    await liveService.enterRoom(
      sdkAppId: ENV.I.sdkAppId,
      userId: AppStore.userId,
      userSig: GenerateUserSig.genTestSig(AppStore.userId),
      roomId: 1001,
      role: TRTCCloudDef.TRTCRoleAnchor,
      scene: TRTCCloudDef.TRTC_APP_SCENE_LIVE,
    );
  }

  @override
  void dispose() {
    enterRoomSuccessNotifier.dispose();
    // Clean up controller resources
    controller.stopCamera();
    controller.stopMicrophone();
    liveService.exitRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: TRTCCloudVideoView(
          onViewCreated: (viewId) {
            liveService.startLocalStream(isFrontCamera: false, viewId: viewId);
          },
        ),
      ),
    );
  }
}