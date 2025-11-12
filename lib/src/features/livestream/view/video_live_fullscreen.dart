import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';
import 'package:mobile_concert/src/config/env/env.dart';
import 'package:mobile_concert/src/features/home/cubit/home_cubit.dart';
import 'package:mobile_concert/src/features/livestream/modal/stream_reaction_enum.dart';
import 'package:mobile_concert/src/network/model/post.dart';
import 'package:mobile_concert/src/network/model/user.dart';
import 'package:mobile_concert/src/router/coordinator.dart';
import 'package:mobile_concert/src/services/tencent_cloud_service.dart';
import 'package:mobile_concert/src/theme/colors.dart';
import 'package:mobile_concert/src/theme/styles.dart';
import 'package:mobile_concert/src/theme/values.dart';
import 'package:mobile_concert/src/utils/app_store.dart';
import 'package:mobile_concert/src/utils/generate_user_sig.dart';
import 'package:mobile_concert/widgets/avatar/avatar.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';

class VideoLiveFullScreen extends StatefulWidget {
  const VideoLiveFullScreen({super.key, required this.post});
  final MPost post;

  @override
  State<VideoLiveFullScreen> createState() => _VideoLiveFullScreenState();
}

class _VideoLiveFullScreenState extends State<VideoLiveFullScreen> {
  final liveService = TencentLiveCloudService();
  late MUser owner;

  @override
  void initState() {
    owner = widget.post.ownerUser ?? MUser.empty();
    _initStreamData();

    super.initState();
  }

  @override
  void dispose() {
    liveService.exitRoom();
    super.dispose();
  }

  Future<void> _initStreamData() async {
    await liveService.enterRoom(
      sdkAppId: ENV.I.sdkAppId,
      userId: AppStore.userId,
      userSig: GenerateUserSig.genTestSig(AppStore.userId),
      roomId: widget.post.streamRoom,
      role: TRTCCloudDef.TRTCRoleAudience,
      scene: TRTCCloudDef.TRTC_APP_SCENE_LIVE,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            TRTCCloudVideoView(
              onViewCreated: (viewId) {
                liveService.startRemoteStream(
                  userId: widget.post.streamHostId,
                  viewId: viewId,
                );
              },
            ),
            Positioned(top: 8, left: 8, child: _renderStreamerAvatar()),
            Positioned(top: 8, right: 8, child: _renderTopLeftSection()),
            Positioned(bottom: 8, left: 8, right: 8, child: _renderBottomBar()),
          ],
        ),
      ),
    );
  }

  Widget _renderStreamerAvatar() {
    return Container(
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: AppColors.grey.withAlpha(200),
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          XAvatar(
            url: owner.avatar,
            imageSize: AppSizes.s24,
            borderWidth: AppSizes.s0,
          ),
          SizedBox(width: AppPadding.p8),
          Text(
            owner.name,
            style: AppStyles.titleSmall.copyWith(color: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget _renderTopLeftSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _renderViewer(),
        SizedBox(width: AppPadding.p4),
        _renderCloseButton(),
      ],
    );
  }

  Widget _renderViewer() {
    final listDisplayUser = GetIt.I.get<HomeCubit>().getRandomUser(owner.id);
    return ReactionAvatarsWidget(users: listDisplayUser, totalCount: 120);
  }

  Widget _renderCloseButton() {
    return GestureDetector(
      onTap: () => AppCoordinator.pop(),
      child: Assets.svgs.icHome.svg(
        width: AppSizes.s24,
        colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
      ),
    );
  }

  Widget _renderBottomBar() {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        _renderListReactionButton(),
      ],
    );
  }

  Widget _renderListReactionButton() {
    return Row(
      children: [
        Assets.svgs.icStreamHeart.svg(width: AppSizes.s40),
        SizedBox(width: AppPadding.p8),
        Assets.svgs.icStreamLike.svg(width: AppSizes.s40),
        SizedBox(width: AppPadding.p8),
        Assets.svgs.icStreamGift.svg(width: AppSizes.s40),
      ],
    );
  }

  Widget _renderReactionButton(SvgGenImage icon, StreamReaction react) {
    return GestureDetector();
  }
}

class ReactionAvatarsWidget extends StatelessWidget {
  const ReactionAvatarsWidget({
    super.key,
    required this.users,
    required this.totalCount,
    this.dimension = 24,
    this.offset = 8,
    this.limit = 3,
    this.color = Colors.black,
    this.justAvatar = false,
  });

  final List<MUser?> users;
  final double dimension;
  final double offset;
  final int limit;
  final int totalCount;
  final Color color;
  final bool justAvatar;

  @override
  Widget build(BuildContext context) {
    final visibleItemCount = min(users.length, limit);
    return Container(
      padding: EdgeInsets.all(AppPadding.p4),
      width: 100.0,
      // height: dimension,
      decoration: BoxDecoration(
        color: AppColors.grey.withAlpha(200),
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: dimension,
            child: Stack(
              children: [
                // * This SizedBox determine the Stack width. It creates tap
                // * area for GestureDetector
                SizedBox(
                  height: dimension,
                  width:
                      (dimension - offset) * (visibleItemCount - 1) + dimension,
                ),
                ...List.generate(
                  visibleItemCount,
                  (index) => Positioned(
                    left: (dimension - offset) * index,
                    child: _avatarCircle(url: users[index]?.avatar ?? ''),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(child: _buildMoreText(context)),
        ],
      ),
    );
  }

  Widget _buildMoreText(BuildContext context) {
    return Text(
      "$totalCount+",
      style: AppStyles.titleSmall.copyWith(color: AppColors.black),
    );
  }

  Widget _avatarCircle({String url = ''}) {
    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 1, color: AppColors.scaffoldBackgroundColor),
      ),
      child: ClipOval(
        child: XAvatar(url: url, imageSize: dimension, borderWidth: 0),
      ),
    );
  }
}
