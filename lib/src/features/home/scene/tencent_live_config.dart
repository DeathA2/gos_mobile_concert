import 'package:flutter/material.dart';

// Configuration helper for Tencent Live UIKit
class TencentLiveConfig {
  static final TencentLiveConfig _instance = TencentLiveConfig._internal();
  
  factory TencentLiveConfig() => _instance;
  
  TencentLiveConfig._internal();
  
  BuildContext? _appContext;
  
  // Initialize the configuration with app context
  void initialize(BuildContext context) {
    _appContext = context;
  }
  
  BuildContext? get appContext => _appContext;
  
  // Default fallback texts for localization
  static const Map<String, String> defaultTexts = {
    'common_more': 'More',
    'common_app_running': 'App is running in background',
    'live_room_anchor': 'Anchor',
    'live_room_co_host': 'Co-host', 
    'live_room_co_guest': 'Co-guest',
    'live_room_settings': 'Settings',
    'live_room_beauty': 'Beauty',
    'live_room_music': 'Music',
    'live_room_flip': 'Flip',
    'live_room_mute': 'Mute',
    'live_room_unmute': 'Unmute',
    'live_room_camera_off': 'Camera Off',
    'live_room_camera_on': 'Camera On',
  };
  
  // Safe method to get localized text
  static String getLocalizedText(String key, {String? fallback}) {
    return fallback ?? defaultTexts[key] ?? key;
  }
}