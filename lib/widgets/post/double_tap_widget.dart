import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';

class XDoubleTapLike extends StatefulWidget {
  const XDoubleTapLike({
    super.key,
    required this.child,
    required this.onLiked,
    this.iconSize = 120,
    this.animationDuration = const Duration(milliseconds: 700),
    this.haptic = true,
  });

  final Widget child;
  final VoidCallback onLiked;

  final double iconSize;

  final Duration animationDuration;

  final bool haptic;

  @override
  State<XDoubleTapLike> createState() => _XDoubleTapLikeState();
}

class _XDoubleTapLikeState extends State<XDoubleTapLike>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Offset? _tapLocal;
  bool _show = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _show = false);
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerLikeAt(Offset localPosition) {
    _tapLocal = localPosition;
    setState(() => _show = true);

    if (widget.haptic) HapticFeedback.lightImpact();
    widget.onLiked();

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onDoubleTapDown: (details) => _triggerLikeAt(details.localPosition),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: widget.child),

          if (_show && _tapLocal != null)
            Builder(
              builder: (context) {
                final size = widget.iconSize;
                final left = _tapLocal!.dx - size / 2;
                final top = _tapLocal!.dy - size / 2;
                return Positioned(
                  left: left,
                  top: top,
                  child: Assets.lotties.love.lottie(
                    width: size,
                    controller: _controller,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
