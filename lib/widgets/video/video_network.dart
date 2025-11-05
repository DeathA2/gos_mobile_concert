import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

/// Custom reusable video player widget using Chewie + cached_video_player_plus
class XCachedVideo extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool loop;
  final double? aspectRatio;
  final Widget? placeholder;
  final Widget? errorWidget;

  const XCachedVideo({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.loop = false,
    this.aspectRatio,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<XCachedVideo> createState() => _XCachedVideoState();
}

class _XCachedVideoState extends State<XCachedVideo> {
  late CachedVideoPlayerPlus _cachedPlayer;
  ChewieController? _chewieController;

  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _cachedPlayer = CachedVideoPlayerPlus.networkUrl(
        Uri.parse(widget.videoUrl),
        invalidateCacheIfOlderThan: const Duration(days: 7),
      );

      await _cachedPlayer.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _cachedPlayer.controller,
        autoPlay: widget.autoPlay,
        looping: widget.loop,
        showControlsOnInitialize: false,
        materialSeekButtonSize: 20,
        showOptions: false,
        aspectRatio:
            widget.aspectRatio ?? _cachedPlayer.controller.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return widget.errorWidget ??
              Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
        },
        placeholder: widget.placeholder,
        showControls: true,
        allowFullScreen: true,
      );

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint("Error initializing video: $e");
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _cachedPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.errorWidget ??
          const Center(child: Icon(Icons.error, color: Colors.red));
    }

    if (!_isInitialized || _chewieController == null) {
      return widget.placeholder ??
          const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _cachedPlayer.controller.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}
