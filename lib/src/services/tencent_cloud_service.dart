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
  int _currentViewId = 0;

  // final Map<String, VideoOrientation> _userOrientation = {};

  Function(bool available)? _remoteVideoAvailableCallback;

  set remoteVideoAvailableCallback(Function(bool available)? callback) {
    _remoteVideoAvailableCallback = callback;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    _trtcCloud = await TRTCCloud.sharedInstance();
    _trtcCloud?.registerListener(_onTrtcListener);
    _isInitialized = true;
  }

  Future<TRTCCloud> get trtc async {
    if (!_isInitialized) {
      await init();
    }
    return _trtcCloud!;
  }

  set viewId(int id) {
    _currentViewId = id;
  }

  int get getViewId => _currentViewId;

  Future<void> enterRoom({
    required int sdkAppId,
    required String userId,
    required String userSig,
    required int roomId,
    required int role,
    required int scene,
  }) async {
    await init();
    final trtc = await TencentLiveCloudService().trtc;
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
    final trtc = await TencentLiveCloudService().trtc;
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
    int? fillMode,
  }) async {
    final trtc = await TencentLiveCloudService().trtc;
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
      TRTCRenderParams(
        fillMode: fillMode ?? TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FIT,
      ),
    );
    await trtc.startRemoteView(
      userId,
      TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG,
      viewId,
    );
  }

  Future<void> exitRoom() async {
    final trtc = await TencentLiveCloudService().trtc;
    await trtc.exitRoom();
  }

  Future<void> dispose() async {
    await TRTCCloud.destroySharedInstance();
    _trtcCloud = null;
    _isInitialized = false;
  }

  void stopRemoteStream(String userId) {
    _trtcCloud?.stopRemoteView(userId, TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG);
  }

  void _onTrtcListener(TRTCCloudListener type, dynamic params) {
    switch (type) {
      case TRTCCloudListener.onFirstVideoFrame:
        break;

      case TRTCCloudListener.onUserVideoAvailable:
        final bool available = params['available'] ?? false;
        _remoteVideoAvailableCallback?.call(available);
        break;

      default:
        break;
    }
  }
}
