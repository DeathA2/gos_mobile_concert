import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';
import 'package:mobile_concert/src/config/constants/constants.dart';
import 'package:mobile_concert/src/config/env/env.dart';
import 'package:mobile_concert/src/features/home/cubit/home_cubit.dart';
import 'package:mobile_concert/src/network/model/post.dart';
import 'package:mobile_concert/src/network/model/user.dart';
import 'package:mobile_concert/src/router/coordinator.dart';
import 'package:mobile_concert/src/services/tencent_cloud_service.dart';
import 'package:mobile_concert/src/theme/colors.dart';
import 'package:mobile_concert/src/theme/styles.dart';
import 'package:mobile_concert/src/theme/values.dart';
import 'package:mobile_concert/src/utils/date/date_helper.dart';
import 'package:mobile_concert/widgets/avatar/avatar.dart';
import 'package:mobile_concert/widgets/card/live_video.dart';
import 'package:mobile_concert/widgets/post/media_layout_view.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';

class XSocialPost extends StatefulWidget {
  final MPost postInfo;

  const XSocialPost({super.key, required this.postInfo});

  @override
  State<XSocialPost> createState() => _XSocialPostState();
}

class _XSocialPostState extends State<XSocialPost> {
  late MUser? userInfo;
  int like = 0;
  int comment = 0;
  int share = 0;
  MUser? randomUser;
  String postId = "";

  @override
  void initState() {
    userInfo = widget.postInfo.ownerUser;
    postId = widget.postInfo.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          like = _randomDoubleInRange(1000, 10000);
          comment = _randomDoubleInRange(10, 99);
          share = _randomDoubleInRange(1000, 10000);
          final listUser = GetIt.I<HomeCubit>().state.listUser;
          listUser.retainWhere((user) => user.id != userInfo?.id);
          randomUser = listUser[_randomDoubleInRange(0, listUser.length - 1)];
        });
      }
    });
    super.initState();
  }

  int _randomDoubleInRange(int min, int max) {
    return min + Random().nextInt(max - min + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _renderUserInfoSection(),
        _renderPostMedia(),
        const SizedBox(height: 4),
        _renderReactionSection(),
        _renderLikeContent(),
        _renderPostContent(),
      ],
    );
  }

  Widget _renderLikeContent() {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 4),
      width: double.infinity,
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (pre, cur) => pre.likedPosts != cur.likedPosts,
        builder: (context, state) {
          return RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                TextSpan(text: 'Liked by ', style: AppStyles.body),
                if (context.read<HomeCubit>().alreadyLikedPost(postId))
                  TextSpan(
                    text: "You, ",
                    style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                TextSpan(
                  text: randomUser?.name,
                  style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' and ', style: AppStyles.body),
                TextSpan(
                  text: 'others',
                  style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _renderUserInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _renderAvatar(),
          SizedBox(width: 8.0),
          Expanded(child: _renderUserInfo()),
          SizedBox(width: 8.0),
          Assets.svgs.icMore.svg(width: 28, height: 28),
        ],
      ),
    );
  }

  Widget _renderAvatar() {
    return XAvatar(
      url: ENV.I.imageURL + (userInfo?.avatar ?? ""),
      imageSize: 36.0,
      borderWidth: 0.0,
    );
  }

  Widget _renderUserInfo() {
    final postTime = DateHelper.getDateChatDetails(widget.postInfo.createAt);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(userInfo?.name ?? '', style: AppStyles.title),
            SizedBox(width: 4),
            Assets.svgs.icVerify.svg(width: 12, height: 12),
          ],
        ),
        Text(postTime, style: AppStyles.inputStyle),
      ],
    );
  }

  Widget _renderPostContent() {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
      width: double.infinity,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: userInfo?.name ?? '',
              style: AppStyles.title.copyWith(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: ' '),
            TextSpan(text: widget.postInfo.content, style: AppStyles.body),
          ],
        ),
      ),
    );
  }

  Widget _renderPostMedia() {
    if (widget.postInfo.isStream) {
      return _renderStreamView();
    }
    List<String> medias = widget.postInfo.medias
        .map((e) => !e.contains("http") ? ENV.I.imageURL + e : e)
        .toList();
    return XMediaLayoutView(
      listMediaUrl: medias,
      onDoubleTapMedia: () => {
        context.read<HomeCubit>().updateLikedPost(postId, forceLike: true),
      },
      // onTapMedia: (index) => AppCoordinator.showMediaDetail(
      //   medias,
      //   post: widget.postInfo,
      //   index: index,
      // ),
    );
  }

  Widget _renderStreamView() {
    return GestureDetector(
      onTap: () async {
        await AppCoordinator.showLiveStreamFullScreen(
          post: widget.postInfo,
          messages: [
            "Minh: Idol ơi hát bài này đi 🎤",
            "Lan: Hay quáaaa 😍",
            "Phong: Mọi người thả tim nào ❤️",
            "Huy: Chất lượng quá 🔥",
            "My: Gửi 100 xu nè 💎",
          ],
        );

        Future.delayed(Durations.medium4, () {
          TencentLiveCloudService().startRemoteStream(
            userId: widget.postInfo.streamHostId,
            viewId: TencentLiveCloudService().getViewId,
            fillMode: TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FILL,
          );
        });
      },

      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: AppConstants.mediaMaxHeight,
            color: AppColors.black,
            child: LiveVideoCustom(
              hostId: widget.postInfo.streamHostId,
              roomId: widget.postInfo.streamRoom,
            ),
          ),
          Positioned(
            top: AppPadding.p12,
            left: AppPadding.p12,
            child: _renderStreamLabel(),
          ),
        ],
      ),
    );
  }

  Widget _renderStreamLabel() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p4,
      ),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.fiber_smart_record_rounded,
            size: AppSizes.s16,
            color: AppColors.scaffoldBackgroundColor,
          ),
          SizedBox(width: AppPadding.p4),
          Text(
            "LIVE",
            style: AppStyles.title.copyWith(
              color: AppColors.scaffoldBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderReactionSection() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) {
              final prevLiked = previous.likedPosts.contains(postId);
              final currLiked = current.likedPosts.contains(postId);
              return prevLiked != currLiked;
            },
            builder: (context, state) {
              bool isLiked = context.read<HomeCubit>().alreadyLikedPost(
                widget.postInfo.id,
              );
              return _renderReaction(
                icon: isLiked
                    ? Assets.svgs.icFavouriteActive.path
                    : Assets.svgs.icFavourite.path,
                total: isLiked ? like + 1 : like,
                color: Colors.red,
                isLiked: isLiked,
                onTap: () => context.read<HomeCubit>().updateLikedPost(
                  widget.postInfo.id,
                ),
              );
            },
          ),
          SizedBox(width: 12),
          _renderReaction(icon: Assets.svgs.icComment.path, total: comment),
          SizedBox(width: 12),
          _renderReaction(icon: Assets.svgs.icMessenger.path, total: share),
          Spacer(),
          Assets.svgs.icSave.svg(),
        ],
      ),
    );
  }

  Widget _renderReaction({
    required String icon,
    required int total,
    VoidCallback? onTap,
    bool isLiked = false,
    Color color = Colors.black,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
            colorFilter: isLiked
                ? ColorFilter.mode(color, BlendMode.srcIn)
                : null,
          ),
          const SizedBox(width: 4),
          Text(
            '$total',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
