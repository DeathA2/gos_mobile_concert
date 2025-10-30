import 'package:flutter/material.dart';
import 'package:mobile_concert/src/network/mock/mock_data.dart';
import 'package:mobile_concert/widgets/post/social_post.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverList.builder(
              itemCount: MockData.listPost.length,
              itemBuilder: (_, index) =>
                  XSocialPost(postInfo: MockData.listPost[index]),
            ),
          ],
        ),
      ),
    );
  }
}
