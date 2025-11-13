import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MinimalCenterControls extends StatefulWidget {
  const MinimalCenterControls({super.key});

  @override
  State<MinimalCenterControls> createState() => _MinimalCenterControlsState();
}

class _MinimalCenterControlsState extends State<MinimalCenterControls> {
  bool _visible = true;
  bool _isEnded = false;
  Timer? _hideTimer;
  VideoPlayerController? _video;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final chewie = ChewieController.of(context);
      _video = chewie.videoPlayerController;

      _video!.addListener(_videoListener);
      _initialized = true;

      _startHideTimer();
    }
  }

  void _videoListener() {
    if (_video == null) return;

    final isFinished =
        _video!.value.position >= _video!.value.duration &&
        !_video!.value.isPlaying;

    if (isFinished && !_isEnded) {
      setState(() {
        _isEnded = true;
        _visible = true;
      });
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _video?.removeListener(_videoListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chewie = ChewieController.of(context);
    final isFull = chewie.isFullScreen;
    final video = _video!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() => _visible = !_visible);
        if (_visible) _startHideTimer();
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _visible ? 1 : 0,
        curve: Curves.easeInOut,
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  if (_isEnded) {
                    video.seekTo(Duration.zero);
                    video.play();
                    setState(() {
                      _isEnded = false;
                      _visible = false;
                    });
                  } else {
                    video.value.isPlaying ? video.pause() : video.play();
                  }
                  _startHideTimer();
                  setState(() {});
                },
                child: Icon(
                  _isEnded
                      ? Icons.replay
                      : (video.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill),
                  color: Colors.white.withAlpha(200),
                  size: 70,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  if (isFull) {
                    chewie.exitFullScreen();
                  } else {
                    chewie.enterFullScreen();
                  }
                  setState(() {});
                  _startHideTimer();
                },
                child: Icon(
                  isFull ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
