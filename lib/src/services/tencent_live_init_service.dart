import 'package:flutter/material.dart';
import 'package:tencent_live_uikit/tencent_live_uikit.dart';
import 'package:mobile_concert/src/store/app_store.dart';
import 'package:mobile_concert/src/utils/generate_user_sig.dart';
import 'package:rtc_room_engine/rtc_room_engine.dart';

class TencentLiveInitService {
  static final TencentLiveInitService _instance =
      TencentLiveInitService._internal();

  factory TencentLiveInitService() => _instance;

  TencentLiveInitService._internal();

  bool _isInitialized = false;

  Future<void> initialize(BuildContext context) async {
    if (_isInitialized) return;

    try {
      await _initializeTIMAndRoomEngine();

      await Future.delayed(const Duration(milliseconds: 100));

      if (context.mounted) {
        // Force a rebuild to ensure proper context initialization
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            _isInitialized = true;
          }
        });
      }
    } catch (e) {
      debugPrint('Error initializing TencentLive: $e');
    }
  }

  Future<void> _initializeTIMAndRoomEngine() async {
    try {
      // Initialize TIM SDK if needed
      final sdkAppId = GenerateUserSig.sdkAppId;
      final userId = AppStore.userId;

      debugPrint('SDK App ID: $sdkAppId');
      debugPrint('User ID: $userId');

      if (userId.isEmpty) {
        debugPrint('ERROR: User ID is empty, cannot initialize TIM SDK');
        return;
      }

      final userSig = GenerateUserSig.genTestSig(userId);
      debugPrint('Generated UserSig: ${userSig.substring(0, 20)}...');
      final loginResult = await TUIRoomEngine.login(sdkAppId, userId, userSig);

      debugPrint(
        'Login result: code=${loginResult.code}, message=${loginResult.message}',
      );

      if (loginResult.code == TUIError.success) {
        debugPrint('✅ TIM SDK login successful');
      } else {
        debugPrint('❌ TIM SDK login failed: ${loginResult.message}');
      }

      // Set self info
      await TUIRoomEngine.setSelfInfo(
        AppStore.userName.value,
        AppStore.userAvatar,
      );
    } catch (e) {
      debugPrint('Error initializing TIM SDK: $e');
    }
  }

  // Get safe localized text with fallback
  static String getSafeLocalizedText(
    BuildContext? context,
    String key, {
    String? fallback,
  }) {
    if (context == null) {
      return fallback ?? _defaultTexts[key] ?? key;
    }

    try {
      // Try to get localized text from TencentLive localizations
      final localizations = Localizations.of<dynamic>(context, dynamic);
      if (localizations != null) {
        return fallback ?? _defaultTexts[key] ?? key;
      }
    } catch (e) {
      // If localization fails, return fallback
    }

    return fallback ?? _defaultTexts[key] ?? key;
  }

  static const Map<String, String> _defaultTexts = {
    'common_more': 'More',
    'common_app_running': 'App is running in background',
    'live_room_anchor': 'Anchor',
    'live_room_co_host': 'Co-host',
    'live_room_co_guest': 'Co-guest',
    'live_room_settings': 'Settings',
    'live_room_beauty': 'Beauty',
    'live_room_music': 'Music',
    'live_room_flip': 'Flip Camera',
    'live_room_mute': 'Mute',
    'live_room_unmute': 'Unmute',
    'live_room_camera_off': 'Camera Off',
    'live_room_camera_on': 'Camera On',
    'live_room_start': 'Start Live',
    'live_room_stop': 'Stop Live',
    'live_room_share': 'Share',
    'live_room_viewers': 'Viewers',
    'live_room_likes': 'Likes',
  };
}
