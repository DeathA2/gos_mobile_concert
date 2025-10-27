import 'package:flutter/material.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';
import 'package:mobile_concert/widgets/post/media_layout_view.dart';

class XSocialPost extends StatefulWidget {
  const XSocialPost({super.key});

  @override
  State<XSocialPost> createState() => _XSocialPostState();
}

class _XSocialPostState extends State<XSocialPost> {
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
    return CircleAvatar(radius: 18.0, child: Assets.svgs.emptyPhoto.svg());
  }

  Widget _renderUserInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text("'Lance'Mark"), Text("2h")],
    );
  }

  Widget _renderPostOptions() {
    return Icon(Icons.more_vert_rounded);
  }

  Widget _renderPostSection() {
    return Column(children: [_renderPostContent(), _renderPostMedia()]);
  }

  Widget _renderPostContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
      child: Text(
        "ashdgasdhasgdhashdgjhasgdhgadgajdghjasgdhjasgdgasdgasdgajsdgjhasgdhjasgdhjagsdhasgdhjgasd",
      ),
    );
  }

  Widget _renderPostMedia() {
    return XMediaLayoutView(
      listMediaUrl: [
        "https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/500426432_2563513020664851_3109461176532767756_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=833d8c&_nc_ohc=ByD_l3_LsLEQ7kNvwF5nrqB&_nc_oc=AdkVsI3skXDtWF2wcGRRFeAf-YvvwD4UAdIeKW82sZXSTVHrfEDxhIHibyAJ13epXe6SLnVZbqFpmYUM9-Jmicke&_nc_zt=23&_nc_ht=scontent.fsgn2-11.fna&_nc_gid=t8yOqjUVGxlbXRI29F9bzg&oh=00_AffdSkDXExMJ7kEgX6rovZTmg7B-a0pGn8CT7V1sSfCHdQ&oe=69055C9E",
        "https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/500426432_2563513020664851_3109461176532767756_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=833d8c&_nc_ohc=ByD_l3_LsLEQ7kNvwF5nrqB&_nc_oc=AdkVsI3skXDtWF2wcGRRFeAf-YvvwD4UAdIeKW82sZXSTVHrfEDxhIHibyAJ13epXe6SLnVZbqFpmYUM9-Jmicke&_nc_zt=23&_nc_ht=scontent.fsgn2-11.fna&_nc_gid=t8yOqjUVGxlbXRI29F9bzg&oh=00_AffdSkDXExMJ7kEgX6rovZTmg7B-a0pGn8CT7V1sSfCHdQ&oe=69055C9E",
        "https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/497863430_2553066201709533_93243012629375990_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=833d8c&_nc_ohc=8yMcIZRqbksQ7kNvwGfZgXt&_nc_oc=AdkTJMoEtvAfKEThGpAZuCbeAp9aY9a3hEmxElXPsIOgSb9fpeIceH3rqJ9XRvtLkcJ6RwnJaORe3xmdQ1iD5Nr8&_nc_zt=23&_nc_ht=scontent.fsgn2-11.fna&_nc_gid=qzj2yLxHy_ltuegS415_yw&oh=00_AfcQ8ywp1BKrqKC9q_LIu1k2cgJWYu2vM5y1gIzG3NyMfQ&oe=690576E9",
        "https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/497863430_2553066201709533_93243012629375990_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=833d8c&_nc_ohc=8yMcIZRqbksQ7kNvwGfZgXt&_nc_oc=AdkTJMoEtvAfKEThGpAZuCbeAp9aY9a3hEmxElXPsIOgSb9fpeIceH3rqJ9XRvtLkcJ6RwnJaORe3xmdQ1iD5Nr8&_nc_zt=23&_nc_ht=scontent.fsgn2-11.fna&_nc_gid=qzj2yLxHy_ltuegS415_yw&oh=00_AfcQ8ywp1BKrqKC9q_LIu1k2cgJWYu2vM5y1gIzG3NyMfQ&oe=690576E9",
      ],
    );
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
