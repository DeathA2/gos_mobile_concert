import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';

class TencentLiveCloudService {
  static final TencentLiveCloudService _instance =
      TencentLiveCloudService._internal();

  factory TencentLiveCloudService() => _instance;

  TencentLiveCloudService._internal();

  // SDK instance
  TRTCCloud? _trtcCloud;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _trtcCloud = await TRTCCloud.sharedInstance();
    _isInitialized = true;
  }

  TRTCCloud get trtc {
    if (_trtcCloud == null) {
      throw Exception('TencentLiveCloudService chưa được init()');
    }
    return _trtcCloud!;
  }

  Future<void> enterRoom({
    required int sdkAppId,
    required String userId,
    required String userSig,
    required int roomId,
    required int role,
    required int scene,
  }) async {
    await init();
    await trtc.enterRoom(
      TRTCParams(
        sdkAppId: sdkAppId,
        userId: userId,
        userSig: userSig,
        roomId: roomId,
        role: role,
      ),
      scene,
    );
  }

  Future<void> startLocalStream({
    required bool isFrontCamera,
    required int viewId,
  }) async {
    await trtc.startLocalPreview(isFrontCamera, viewId);
    await trtc.setLocalRenderParams(
      TRTCRenderParams(mirrorType: TRTCCloudDef.TRTC_VIDEO_MIRROR_TYPE_DISABLE),
    );
    await trtc.startLocalAudio(TRTCCloudDef.TRTC_AUDIO_QUALITY_MUSIC);
  }

  Future<void> startRemoteStream({
    required String userId,
    required int viewId,
  }) async {
    await trtc.startRemoteView(
      userId,
      TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL,
      viewId,
    );
  }

  Future<void> exitRoom() async {
    await trtc.exitRoom();
  }

  Future<void> dispose() async {
    await TRTCCloud.destroySharedInstance();
    _trtcCloud = null;
    _isInitialized = false;
  }
}
