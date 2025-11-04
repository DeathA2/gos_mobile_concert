import 'package:flutter/material.dart';
import 'package:mobile_concert/src/config/constants/constants.dart';
import 'package:mobile_concert/src/theme/colors.dart';
import 'package:mobile_concert/src/theme/styles.dart';
import 'package:mobile_concert/src/theme/values.dart';
import 'package:mobile_concert/widgets/image/image_network.dart';
import 'package:mobile_concert/widgets/video/video_network.dart';

class XMediaLayoutView extends StatelessWidget {
  final List<String> listMediaUrl;
  final Function(int) onTapMedia;
  const XMediaLayoutView({
    super.key,
    required this.listMediaUrl,
    required this.onTapMedia,
  });

  @override
  Widget build(BuildContext context) {
    final mediaSize = listMediaUrl.length;
    switch (mediaSize) {
      case 0:
        return SizedBox.shrink();
      case 1:
        return _renderSingleMedia(listMediaUrl.first);
      case 2:
        return _renderDoubleMedias();
      case 3:
        return _renderTripleMedias();
      case 4:
      default:
        return _renderSquadMedias();
    }
  }

  Widget _renderSingleMedia(String url, {int index = 0}) {
    final isVideoUrl = url.split(".").lastOrNull?.contains("mp4") ?? false;
    return GestureDetector(
      onTap: () => onTapMedia(index),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: AppConstants.mediaMaxHeight,
          minHeight: AppConstants.mediaMinHeight,
          maxWidth: double.infinity,
          minWidth: double.infinity,
        ),
        child: isVideoUrl
            ? XCachedVideo(videoUrl: url)
            : XImageNetwork(url, fit: BoxFit.cover),
      ),
    );
  }

  Widget _renderDoubleMedias() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: AppConstants.mediaMaxHeight,
        minHeight: AppConstants.mediaMinHeight,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _renderSingleMedia(listMediaUrl.first, index: 0)),
            SizedBox(width: AppPadding.p4),
            Expanded(child: _renderSingleMedia(listMediaUrl.last, index: 1)),
          ],
        ),
      ),
    );
  }

  Widget _renderTripleMedias() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: AppConstants.mediaMaxHeight,
        minHeight: AppConstants.mediaMinHeight,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _renderSingleMedia(listMediaUrl.first, index: 0)),
            SizedBox(width: AppPadding.p4),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _renderSingleMedia(listMediaUrl[1], index: 1),
                  ),
                  SizedBox(height: AppPadding.p4),
                  Expanded(
                    child: _renderSingleMedia(listMediaUrl.last, index: 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderSquadMedias() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: AppConstants.mediaMaxHeight,
        minHeight: AppConstants.mediaMinHeight,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _renderSingleMedia(listMediaUrl.first, index: 0),
                  ),
                  SizedBox(height: AppPadding.p4),
                  Expanded(
                    child: _renderSingleMedia(listMediaUrl[1], index: 1),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppPadding.p4),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _renderSingleMedia(listMediaUrl[2], index: 2),
                  ),
                  SizedBox(height: AppPadding.p4),
                  Expanded(
                    child: Stack(
                      children: [
                        _renderSingleMedia(listMediaUrl[3], index: 3),
                        (listMediaUrl.length > 4)
                            ? _renderMoreMediaLayout(listMediaUrl.length - 4)
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderMoreMediaLayout(int remainCount) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: AppColors.black3.withAlpha(200),
          child: Center(
            child: Text(
              "+$remainCount",
              style: AppStyles.titleLarge.copyWith(
                fontSize: AppFontSize.f30,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
