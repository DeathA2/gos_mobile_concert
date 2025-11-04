import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';
import 'package:mobile_concert/src/network/model/post.dart';
import 'package:mobile_concert/src/network/model/user.dart';
import 'package:mobile_concert/src/router/coordinator.dart';
import 'package:mobile_concert/src/services/local_cache_manager.dart';
import 'package:mobile_concert/src/theme/colors.dart';
import 'package:mobile_concert/src/theme/styles.dart';
import 'package:mobile_concert/src/theme/values.dart';
import 'package:mobile_concert/src/utils/date/date_helper.dart';
import 'package:mobile_concert/widgets/avatar/avatar.dart';
import 'package:mobile_concert/widgets/common/indicator.dart';
import 'package:mobile_concert/widgets/image/image_network.dart';
import 'package:mobile_concert/widgets/image/svg_custom.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewPage extends StatefulWidget {
  const PhotoViewPage({
    super.key,
    this.initialIndex = 0,
    required this.galleryItems,
    required this.postInfor,
  });
  final int initialIndex;
  final List<String> galleryItems;
  final MPost postInfor;

  @override
  State<StatefulWidget> createState() {
    return _PhotoViewPageState();
  }
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  late int currentIndex = widget.initialIndex;
  late PageController pageController;
  double _screenHeight = 0.0;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    pageController = PageController(initialPage: widget.initialIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheAroundIndex(widget.initialIndex);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });

    _precacheAroundIndex(index);
  }

  Future<void> _precacheAroundIndex(int index) async {
    final contextRef = context;
    final urls = widget.galleryItems;

    Future<void> precache(String url) async {
      await precacheImage(
        CachedNetworkImageProvider(
          url,
          cacheKey: url,
          cacheManager: LocalCacheManager.instance,
        ),
        contextRef,
      );
    }

    // preload current
    await precache(urls[index]);

    // preload previous
    if (index > 0) {
      await precache(urls[index - 1]);
    }

    // preload next
    if (index < urls.length - 1) {
      await precache(urls[index + 1]);
    }
  }

  @override
  void didChangeDependencies() {
    if (context.mounted) {
      _screenHeight = MediaQuery.of(context).size.width;
      setState(() {});
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoViewGallery.builder(
              scrollPhysics: const ClampingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: (context, event) => const XIndicator(),
              pageController: pageController,
              onPageChanged: onPageChanged,
              wantKeepAlive: true,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: BackButton(
              color: Colors.white,
              onPressed: () => AppCoordinator.pop(),
            ),
          ),
          Positioned(
            top: _screenHeight / 2,
            right: 12,
            child: _renderReactionColumn(),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: _renderPostInfor(),
          ),
        ],
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.galleryItems[index];

    // return PhotoViewGalleryPageOptions(
    //   imageProvider: CachedNetworkImageProvider(
    //     item,
    //     cacheKey: item,
    //     cacheManager: LocalCacheManager.instance,
    //   ),
    //   initialScale: PhotoViewComputedScale.contained,
    //   minScale: PhotoViewComputedScale.contained,
    //   maxScale: PhotoViewComputedScale.covered * 1.5,
    // );
    return PhotoViewGalleryPageOptions.customChild(
      child: XImageNetwork(item, key: ValueKey(item)),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 1.5,
    );
  }

  Widget _renderReactionColumn() {
    return SizedBox(
      width: AppSizes.s50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _reactionItem(
            XSvgCustom(
              svgPath: Assets.svgs.icHeart,
              svgWidth: AppSizes.s30,
              svgColor: AppColors.white,
            ),
            reactCount: 100,
          ),
          _reactionItem(
            XSvgCustom(
              svgPath: Assets.svgs.icChat,
              svgWidth: AppSizes.s30,
              svgColor: AppColors.white,
            ),
            reactCount: 100,
          ),
        ],
      ),
    );
  }

  Widget _reactionItem(Widget item, {int reactCount = 0}) {
    return Column(
      children: [
        item,
        (reactCount == 0)
            ? SizedBox.shrink()
            : Text(
                reactCount.toString(),
                style: AppStyles.titleLarge.copyWith(color: AppColors.white),
              ),
      ],
    );
  }

  Widget _renderPostInfor() {
    return Column(
      children: [
        if (widget.postInfor.ownerUser != null)
          _userInfo(
            widget.postInfor.ownerUser!,
            createTime: widget.postInfor.createAt,
          ),
        _postBody(widget.postInfor.content),
      ],
    );
  }

  Widget _userInfo(MUser owner, {required DateTime createTime}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _renderAvatar(owner.avatar),
          SizedBox(width: 8.0),
          Expanded(child: _renderUserInfo(owner.name, createTime)),
        ],
      ),
    );
  }

  Widget _renderAvatar(String avatar) {
    return XAvatar(url: avatar, imageSize: 36.0, borderWidth: 0.0);
  }

  Widget _renderUserInfo(String ownerName, DateTime createAt) {
    final postTime = DateHelper.getDateChatDetails(createAt);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ownerName,
          style: AppStyles.title.copyWith(color: AppColors.white),
        ),
        Text(
          postTime,
          style: AppStyles.inputStyle.copyWith(color: AppColors.white),
        ),
      ],
    );
  }

  Widget _postBody(String content) {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
      width: double.infinity,
      child: Text(
        content,
        style: AppStyles.body.copyWith(color: AppColors.white),
      ),
    );
  }
}
