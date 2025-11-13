import 'package:flutter/material.dart';
import 'package:mobile_concert/src/config/env/env.dart';
import 'package:mobile_concert/src/services/tencent_cloud_service.dart';
import 'package:mobile_concert/src/theme/colors.dart';
import 'package:mobile_concert/src/utils/app_store.dart';
import 'package:mobile_concert/src/utils/generate_user_sig.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';

class LiveVideoCustom extends StatefulWidget {
  const LiveVideoCustom({
    super.key,
    required this.hostId,
    required this.roomId,
  });
  final String hostId;
  final int roomId;

  @override
  State<LiveVideoCustom> createState() => _LiveVideoCustomState();
}

class _LiveVideoCustomState extends State<LiveVideoCustom> {
  final liveService = TencentLiveCloudService();
  bool _remoteVideoAvailable = false;

  @override
  void initState() {
    super.initState();
    _initStreamData();
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
      roomId: widget.roomId,
      role: TRTCCloudDef.TRTCRoleAudience,
      scene: TRTCCloudDef.TRTC_APP_SCENE_LIVE,
    );

    liveService.remoteVideoAvailableCallback = (available) {
      setState(() => _remoteVideoAvailable = available);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TRTCCloudVideoView(
          onViewCreated: (viewId) {
            liveService.viewId = viewId;
            liveService.startRemoteStream(
              userId: widget.hostId,
              viewId: viewId,
              fillMode: TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FILL,
            );
          },
        ),
        if (!_remoteVideoAvailable)
          Positioned.fill(
            child: Container(
              color: AppColors.black,
              child: const Center(
                child: Text(
                  "This stream has ended",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
