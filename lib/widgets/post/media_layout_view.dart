import 'package:flutter/material.dart';
import 'package:mobile_concert/src/config/constants/constants.dart';
import 'package:mobile_concert/src/theme/values.dart';
import 'package:mobile_concert/widgets/image/image_network.dart';

class XMediaLayoutView extends StatelessWidget {
  final List<String> listMediaUrl;
  const XMediaLayoutView({super.key, required this.listMediaUrl});

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

  Widget _renderSingleMedia(String url) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: AppConstants.mediaMaxHeight,
        minHeight: AppConstants.mediaMinHeight,
        maxWidth: double.infinity,
        minWidth: double.infinity,
      ),
      child: XImageNetwork(url, fit: BoxFit.cover),
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
            Expanded(child: _renderSingleMedia(listMediaUrl.first)),
            SizedBox(width: AppPadding.p4),
            Expanded(child: _renderSingleMedia(listMediaUrl.last)),
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
            Expanded(child: _renderSingleMedia(listMediaUrl.first)),
            SizedBox(width: AppPadding.p4),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _renderSingleMedia(listMediaUrl.last)),
                  SizedBox(height: AppPadding.p4),
                  Expanded(child: _renderSingleMedia(listMediaUrl.last)),
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
                  Expanded(child: _renderSingleMedia(listMediaUrl.first)),
                  SizedBox(height: AppPadding.p4),
                  Expanded(child: _renderSingleMedia(listMediaUrl.first)),
                ],
              ),
            ),
            SizedBox(width: AppPadding.p4),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _renderSingleMedia(listMediaUrl.last)),
                  SizedBox(height: AppPadding.p4),
                  Expanded(child: _renderSingleMedia(listMediaUrl.last)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
