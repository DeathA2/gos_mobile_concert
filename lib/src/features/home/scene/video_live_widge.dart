import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream_core/live_core_widget/live_core_widget.dart';
import 'package:tencent_live_uikit/tencent_live_uikit.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mobile_concert/src/features/home/cubit/home_cubit.dart';
import 'package:mobile_concert/src/services/tencent_live_init_service.dart';
import 'package:mobile_concert/src/store/app_store.dart';

class VideoLiveWidget extends StatefulWidget {
  const VideoLiveWidget({super.key});

  @override
  State<VideoLiveWidget> createState() => _VideoLiveWidgetState();
}

class _VideoLiveWidgetState extends State<VideoLiveWidget> {
  late double _screenWidth;
  late double _screenHeight;
  final enterRoomSuccessNotifier = ValueNotifier<bool>(false);
  String currentRoomId = '';
  bool _isInitializing = false;

  final controller = LiveCoreController();

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

    try {
      debugPrint('=== Initializing Tencent Live ===');

      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      final homeCubit = context.read<HomeCubit>();
      if (!homeCubit.state.isLoggedIn) {
        debugPrint('Waiting for user login...');
        await Future.delayed(const Duration(seconds: 2));
      }

      debugPrint('Current user ID: ${AppStore.userId}');

      await TencentLiveInitService().initialize(context);

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });

      debugPrint('✅ Tencent Live initialization complete');
    } catch (e) {
      debugPrint('❌ Error initializing Tencent Live: $e');
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    enterRoomSuccessNotifier.dispose();
    // Clean up controller resources
    controller.stopCamera();
    controller.stopMicrophone();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.sizeOf(context).width;
    _screenHeight = MediaQuery.sizeOf(context).height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Clean up before popping
          if (enterRoomSuccessNotifier.value) {
            await _leaveRoom();
          }
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: ValueListenableBuilder(
        valueListenable: AppStore.currentFragmentIndex,
        builder: (BuildContext context, int value, Widget? child) {
          return Scaffold(
            body: SizedBox(
              width: _screenWidth,
              height: double.infinity,
              child: Stack(
                children: [
                  _initTopBackgroundWidget(),
                  _initAppBarWidget(),
                  _initStartLive(),
                  _initBroadcastWidget(),
                  //_buildLiveInfoWidget(),
                  if (_isInitializing)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _initTopBackgroundWidget() {
    return SizedBox(
      width: _screenWidth,
      height: _screenHeight,
      child: Image.asset(
        'assets/images/app_top_background.png',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _initAppBarWidget() {
    return Positioned(
      left: 10,
      top: 40,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            onPressed: () async {
              if (enterRoomSuccessNotifier.value) {
                await _leaveRoom();
              }
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: Image.asset(
              'assets/images/app_back.png',
              width: 24,
              height: 24,
            ),
          ),
          const Text(
            'App Video',
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: Color(0xFF000000),
            ),
          ),
          GestureDetector(
            onTap: () {
              //_launchUrl(AppStore.tuiLiveKitDocumentUrl);
            },
            child: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              color: Colors.transparent,
              child: Image.asset(
                'assets/images/app_question_link.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _initStartLive() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: Container(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: _isInitializing
                ? null
                : () {
                    _joinRoomAsViewer('live_philip');
                  },
            child: Opacity(
              opacity: _isInitializing ? 0.5 : 1.0,
              child: Container(
                width: 154,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C66E5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Join live',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _initBroadcastWidget() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: Container(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: _isInitializing
                ? null
                : () {
                    _startAnchorWidget();
                  },
            child: Opacity(
              opacity: _isInitializing ? 0.5 : 1.0,
              child: Container(
                width: 154,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C66E5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Start live',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension _VideoLiveWidgetStateLogicExtension on _VideoLiveWidgetState {
  void _startAnchorWidget() async {
    debugPrint('=== Starting anchor widget ===');
    debugPrint('Is initializing: $_isInitializing');
    debugPrint('Is mounted: $mounted');

    if (_isInitializing || !mounted) {
      debugPrint(
        'Cannot start: initializing=$_isInitializing, mounted=$mounted',
      );
      return;
    }

    final userId = AppStore.userId;
    debugPrint('User ID: $userId');

    if (userId.isEmpty) {
      _showError('User ID is empty. Please ensure you are logged in.');
      return;
    }

    final roomId = LiveIdentityGenerator.instance.generateId(
      userId,
      RoomType.live,
    );

    print("Generated Room ID11: $roomId");

    // Create live info for live streaming
    final liveInfo = TUILiveInfo();
    liveInfo.roomId = roomId;
    liveInfo.name = 'Live Concert Room ${AppStore.userId}';
    liveInfo.isSeatEnabled = true;
    liveInfo.seatMode = TUISeatMode.applyToTake;
    liveInfo.maxSeatCount = 9;
    liveInfo.keepOwnerOnSeat = true;
    liveInfo.isPublicVisible = true; // Make room publicly visible

    try {
      // Start live stream with live info
      final startLiveStreamResult = await controller.startLiveStreamV2(
        liveInfo,
      );

      if (startLiveStreamResult.code != TUIError.success) {
        _showError(
          'Failed to start live stream: ${startLiveStreamResult.message}',
        );
        return;
      }

      // Start microphone after successfully starting live stream
      final startMicrophoneResult = await controller.startMicrophone();

      if (startMicrophoneResult.code != TUIError.success) {
        await controller.stopLiveStreamV2();
        _showError(
          'Failed to start microphone: ${startMicrophoneResult.message}',
        );
        return;
      }

      // Start camera for video streaming
      final startCameraResult = await controller.startCamera(true);

      if (startCameraResult.code != TUIError.success) {
        controller.stopMicrophone();
        await controller.stopLiveStreamV2();
        _showError('Failed to start camera: ${startCameraResult.message}');
        return;
      }

      // Update the room info when starting as anchor
      if (!mounted) return;

      setState(() {
        currentRoomId = roomId;
        enterRoomSuccessNotifier.value = true;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return TUILiveRoomAnchorWidget(roomId: roomId);
          },
        ),
      );

      // Clean up after returning from anchor screen
      if (!mounted) return;

      await _cleanupLiveStream();
    } catch (e, stackTrace) {
      debugPrint('❌ Error starting live stream: $e');
      debugPrint('Stack trace: $stackTrace');
      await _cleanupLiveStream();
    }
  }

  Future<void> _cleanupLiveStream() async {
    try {
      // Stop camera, microphone and live stream
      controller.stopCamera();
      controller.stopMicrophone();
      await controller.stopLiveStreamV2();

      if (!mounted) return;

      // Reset state
      // setState(() {
      //   enterRoomSuccessNotifier.value = false;
      //   currentRoomId = '';
      // });
    } catch (e) {
      debugPrint('Error cleaning up live stream: $e');
    }
  }

  void _launchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _joinRoomAsViewer(String roomId) async {
    if (!mounted) return;

    try {
      // Join live stream as viewer
      final joinResult = await controller.joinLiveStreamV2(roomId);

      if (joinResult.code == TUIError.success) {
        if (!mounted) return;

        setState(() {
          currentRoomId = roomId;
          enterRoomSuccessNotifier.value = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TUILiveRoomAudienceWidget(roomId: roomId);
            },
          ),
        ).then((_) async {
          // Clean up after returning from audience screen
          await _leaveRoom();
        });
      } else {
        _showError('Failed to join room: ${joinResult.message}');
      }
    } catch (e) {
      debugPrint('Error joining room: $e');
      _showError('Error joining room: $e');
    }
  }

  Future<void> _leaveRoom() async {
    try {
      await controller.leaveLiveStream();

      if (!mounted) return;

      setState(() {
        enterRoomSuccessNotifier.value = false;
        currentRoomId = '';
      });
    } catch (e) {
      debugPrint('Error leaving room: $e');
    }
  }
}
