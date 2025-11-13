import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';
import 'package:mobile_concert/packages/dismiss_keyboard/dismiss_keyboard.dart';
import 'package:mobile_concert/src/features/home/cubit/home_cubit.dart';
import 'package:mobile_concert/src/features/livestream/modal/stream_reaction_enum.dart';
import 'package:mobile_concert/src/network/model/post.dart';
import 'package:mobile_concert/src/network/model/user.dart';
import 'package:mobile_concert/src/router/coordinator.dart';
import 'package:mobile_concert/src/services/tencent_cloud_service.dart';
import 'package:mobile_concert/src/theme/colors.dart';
import 'package:mobile_concert/src/theme/screen.dart';
import 'package:mobile_concert/src/theme/styles.dart';
import 'package:mobile_concert/src/theme/values.dart';
import 'package:mobile_concert/src/utils/app_store.dart';
import 'package:mobile_concert/src/utils/extension.dart';
import 'package:mobile_concert/widgets/avatar/avatar.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';

class VideoLiveFullScreen extends StatefulWidget {
  const VideoLiveFullScreen({
    super.key,
    required this.post,
    required this.messages,
  });
  final MPost post;
  final List<String> messages;

  @override
  State<VideoLiveFullScreen> createState() => _VideoLiveFullScreenState();
}

class _VideoLiveFullScreenState extends State<VideoLiveFullScreen> {
  final liveService = TencentLiveCloudService();
  late MUser owner;

  bool _showLottie = false;
  LottieGenImage? _lottieAsset;

  final List<String> _messages = [];
  final TextEditingController _chatController = TextEditingController();
  int _messIndex = 0;
  Timer? _messTimer;

  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    owner = widget.post.ownerUser ?? MUser.empty();
    _startStreamMessages();

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    liveService.stopRemoteStream(widget.post.streamHostId);
    _chatController.dispose();
    _messTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startStreamMessages() {
    if (widget.messages.isEmpty) return;

    _messTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_messIndex < widget.messages.length) {
        final msg = widget.messages[_messIndex];
        _messages.insert(0, msg);
        _listKey.currentState?.insertItem(0);
        _messIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  void _showReaction(StreamReaction react) {
    String _action = "";
    switch (react) {
      case StreamReaction.love:
        _lottieAsset = Assets.lotties.love;
        _action = "love ❤️";
        break;
      case StreamReaction.like:
        _lottieAsset = Assets.lotties.likeAnimation;
        _action = "like 👍";
        break;
      case StreamReaction.gift:
        _lottieAsset = Assets.lotties.giftAnimation;
        _action = "gift 🎁";
        break;
    }

    setState(() => _showLottie = true);

    final newMsg =
        "${AppStore.userId.capitalize()} has sent a $_action to this Streamer";

    _messages.insert(0, newMsg);
    _listKey.currentState?.insertItem(0);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _showLottie = false);
    });
  }

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    final newMsg = "${AppStore.userId.capitalize()}: $text";

    _messages.insert(0, newMsg);
    _listKey.currentState?.insertItem(0);

    _chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DismissKeyBoard(
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
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: _renderBottomBar(),
              ),

              if (_showLottie && _lottieAsset != null)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54.withAlpha(100),
                    child: Center(
                      child: _lottieAsset?.lottie(
                        width: AppSizes.s200,
                        height: AppSizes.s200,
                        repeat: false,
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChatMessages(),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.divider),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          style: AppStyles.inputStyle.copyWith(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Chat now...",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      GestureDetector(
                        onTap: _sendMessage,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              _renderListReactionButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return SizedBox(
      height: AppSizes.s175,
      width: AppScreens.width * 2 / 3,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double visibleHeight = constraints.maxHeight;

          return AnimatedList(
            key: _listKey,
            controller: _scrollController,
            reverse: true,
            initialItemCount: _messages.length,
            itemBuilder: (context, index, animation) {
              final msg = _messages[index];

              return SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: FadeTransition(
                  opacity: animation,
                  child: _buildChatItem(msg, index, visibleHeight),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildChatItem(String msg, int index, double visibleHeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemHeight = 36;
        final double itemY = index * itemHeight - _scrollOffset;
        final double normalized = (itemY / visibleHeight).clamp(0.0, 1.0);
        final double opacity = 1.0 - normalized * 0.85;

        return Opacity(
          opacity: opacity.clamp(0.2, 1.0),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppPadding.p2),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p12,
                vertical: AppPadding.p4,
              ),
              child: Text(
                msg,
                style: AppStyles.titleSmall.copyWith(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _renderListReactionButton() {
    return Row(
      children: [
        _renderReactionButton(Assets.svgs.icStreamHeart, StreamReaction.love),
        SizedBox(width: AppPadding.p8),
        _renderReactionButton(Assets.svgs.icStreamLike, StreamReaction.like),
        SizedBox(width: AppPadding.p8),
        _renderReactionButton(Assets.svgs.icStreamGift, StreamReaction.gift),
      ],
    );
  }

  Widget _renderReactionButton(SvgGenImage icon, StreamReaction react) {
    return GestureDetector(
      onTap: () => _showReaction(react),
      child: icon.svg(width: AppSizes.s40),
    );
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
