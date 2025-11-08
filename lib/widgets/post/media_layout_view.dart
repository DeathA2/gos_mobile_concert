import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_concert/src/config/constants/constants.dart';
import 'package:mobile_concert/src/services/local_cache_manager.dart';
import 'package:mobile_concert/src/theme/screen.dart';
import 'package:mobile_concert/src/theme/values.dart';
import 'package:mobile_concert/widgets/image/image_network.dart';
import 'package:mobile_concert/widgets/post/double_tap_widget.dart';
import 'package:mobile_concert/widgets/video/video_network.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class XMediaLayoutView extends StatefulWidget {
  final List<String> listMediaUrl;
  final Function(int) onTapMedia;
  final Function(int) onPageChanged;

  const XMediaLayoutView({
    super.key,
    required this.listMediaUrl,
    required this.onTapMedia,
    required this.onPageChanged,
  });

  @override
  State<XMediaLayoutView> createState() => _XMediaLayoutViewState();
}

class _XMediaLayoutViewState extends State<XMediaLayoutView> {
  static const _prefetchRange = 2;

  int currentIndex = 0;
  late final PageController _pageController;
  final _prefetchedIndexes = <int>{};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _prefetchAround(currentIndex);
    });
  }

  @override
  void didUpdateWidget(covariant XMediaLayoutView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listMediaUrl != oldWidget.listMediaUrl) {
      _prefetchedIndexes.clear();

      var newIndex = currentIndex;
      if (widget.listMediaUrl.isEmpty) {
        newIndex = 0;
      } else if (currentIndex >= widget.listMediaUrl.length) {
        newIndex = widget.listMediaUrl.length - 1;
      }

      if (newIndex != currentIndex) {
        setState(() => currentIndex = newIndex);
      }

      if (widget.listMediaUrl.isEmpty) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_pageController.hasClients) {
          _pageController.jumpToPage(currentIndex);
        }
        _prefetchAround(currentIndex);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = widget.listMediaUrl.length;
    return Column(
      children: [
        SizedBox.square(
          dimension: AppScreens.width,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                allowImplicitScrolling: true,
                onPageChanged: (value) {
                  widget.onPageChanged(value);
                  setState(() => currentIndex = value);
                  _prefetchAround(value);
                },
                itemCount: mediaSize,
                itemBuilder: (context, index) {
                  return _renderSingleMedia(
                    widget.listMediaUrl[index],
                    index: index,
                  );
                },
              ),
              if (mediaSize > 1)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${currentIndex + 1}/$mediaSize',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (mediaSize > 1) ...[
          const SizedBox(height: 6),
          SmoothPageIndicator(
            controller: _pageController,
            count: mediaSize,
            effect: ScrollingDotsEffect(
              dotHeight: 6,
              dotWidth: 6,
              spacing: 4,
              dotColor: Colors.black.withValues(alpha: 0.15),
              activeDotColor: Color(0xFF3897F0),
            ),
          ),
        ],
      ],
    );
  }

  Widget _renderSingleMedia(String url, {int index = 0}) {
    return _MediaPage(
      url: url,
      index: index,
      isVideo: _isVideoUrl(url),
      onTapMedia: widget.onTapMedia,
    );
  }

  bool _isVideoUrl(String url) {
    final normalized = url.toLowerCase().split('?').first.split('#').first;
    return normalized.endsWith('.mp4') || normalized.contains("dropbox");
  }

  void _prefetchAround(int index) {
    if (!mounted || widget.listMediaUrl.isEmpty) return;

    for (var offset = -_prefetchRange; offset <= _prefetchRange; offset++) {
      final target = index + offset;
      if (target < 0 || target >= widget.listMediaUrl.length) continue;
      if (_prefetchedIndexes.contains(target)) continue;

      final url = widget.listMediaUrl[target];
      if (_isVideoUrl(url)) continue;

      _prefetchedIndexes.add(target);
      final provider = CachedNetworkImageProvider(
        url,
        cacheKey: url,
        cacheManager: LocalCacheManager.instance,
      );
      precacheImage(provider, context);
    }
  }
}

class _MediaPage extends StatefulWidget {
  const _MediaPage({
    required this.url,
    required this.index,
    required this.isVideo,
    required this.onTapMedia,
  });

  final String url;
  final int index;
  final bool isVideo;
  final Function(int) onTapMedia;

  @override
  State<_MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<_MediaPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return XDoubleTapLike(
      onLiked: () => {},
      iconSize: AppSizes.s200,
      animationDuration: Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () => widget.onTapMedia(widget.index),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: AppConstants.mediaMaxHeight,
            minHeight: AppConstants.mediaMinHeight,
            maxWidth: double.infinity,
            minWidth: double.infinity,
          ),
          child: widget.isVideo
              ? XCachedVideo(videoUrl: widget.url)
              : XImageNetwork(widget.url, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
