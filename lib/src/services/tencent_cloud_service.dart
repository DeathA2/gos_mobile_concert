import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_listener.dart';

class TencentLiveCloudService {
  static final TencentLiveCloudService _instance =
      TencentLiveCloudService._internal();

  factory TencentLiveCloudService() => _instance;

  TencentLiveCloudService._internal();

  // SDK instance
  TRTCCloud? _trtcCloud;
  bool _isInitialized = false;

  // final Map<String, VideoOrientation> _userOrientation = {};

  Future<void> init() async {
    if (_isInitialized) return;
    _trtcCloud = await TRTCCloud.sharedInstance();
    _trtcCloud?.registerListener(_onTrtcListener);
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
    await trtc.setVideoEncoderParam(
      TRTCVideoEncParam(
        videoResolution: TRTCCloudDef.TRTC_VIDEO_RESOLUTION_1280_720,
        videoResolutionMode: TRTCCloudDef.TRTC_VIDEO_RESOLUTION_MODE_PORTRAIT,
        videoFps: 30,
        videoBitrate: 1200,
      ),
    );
  }

  Future<void> startRemoteStream({
    required String userId,
    required int viewId,
  }) async {
    await trtc.setVideoEncoderParam(
      TRTCVideoEncParam(
        videoFps: 30,
        videoBitrate: 1200,
        videoResolution: TRTCCloudDef.TRTC_VIDEO_RESOLUTION_1280_720,
      ),
    );
    await trtc.setRemoteRenderParams(
      userId,
      TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG,
      TRTCRenderParams(fillMode: TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FIT),
    );
    await trtc.startRemoteView(
      userId,
      TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG,
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

  void _onTrtcListener(TRTCCloudListener type, dynamic params) {
    if (type == TRTCCloudListener.onFirstVideoFrame) {
      final String userId = params['userId'] ?? '';
      final int width =
          params['width'] ?? params['newWidth'] ?? params['videoWidth'] ?? 0;
      final int height =
          params['height'] ?? params['newHeight'] ?? params['videoHeight'] ?? 0;

      if (userId.isEmpty || width == 0 || height == 0) return;

      // final orientation = width > height
      //     ? VideoOrientation.landscape
      //     : VideoOrientation.portrait;

      // final previous = _userOrientation[userId];
      // if (previous != orientation) {
      //   _userOrientation[userId] = orientation;
      //   onOrientationChanged?.call(userId, orientation);
      // }
    }
  }
}
