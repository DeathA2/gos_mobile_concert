import 'package:flutter/material.dart';
import 'package:mobile_concert/src/network/model/post.dart';
import 'package:mobile_concert/src/network/model/user.dart';
import 'package:mobile_concert/src/theme/styles.dart';
import 'package:mobile_concert/src/utils/date/date_helper.dart';
import 'package:mobile_concert/widgets/avatar/avatar.dart';
import 'package:mobile_concert/widgets/post/media_layout_view.dart';

class XSocialPost extends StatefulWidget {
  final Post postInfo;

  const XSocialPost({super.key, required this.postInfo});

  @override
  State<XSocialPost> createState() => _XSocialPostState();
}

class _XSocialPostState extends State<XSocialPost> {
  late User userInfo;

  @override
  void initState() {
    userInfo = widget.postInfo.owner;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      child: Column(
        children: [
          _renderUserInfoSection(),
          _renderPostSection(),
          _renderReactionSection(),
          // TODO: Add later
          // _renderCommentSection()
        ],
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
          _renderPostOptions(),
        ],
      ),
    );
  }

  Widget _renderAvatar() {
    return XAvatar(url: userInfo.avatar, imageSize: 36.0, borderWidth: 0.0);
  }

  Widget _renderUserInfo() {
    final postTime = DateHelper.getDateChatDetails(widget.postInfo.createAt);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(userInfo.name, style: AppStyles.title),
        Text(postTime, style: AppStyles.inputStyle),
      ],
    );
  }

  Widget _renderPostOptions() {
    return Icon(Icons.more_vert_rounded);
  }

  Widget _renderPostSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_renderPostContent(), _renderPostMedia()],
    );
  }

  Widget _renderPostContent() {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
      width: double.infinity,
      child: Text(widget.postInfo.content, style: AppStyles.body),
    );
  }

  Widget _renderPostMedia() {
    return XMediaLayoutView(listMediaUrl: widget.postInfo.medias);
  }

  Widget _renderReactionSection() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          _renderReactionButton(),
          _renderReactionButton(),
          _renderReactionButton(),
          _renderReactionButton(),
        ],
      ),
    );
  }

  Widget _renderReactionButton() {
    return Expanded(child: Icon(Icons.heart_broken));
  }
}
