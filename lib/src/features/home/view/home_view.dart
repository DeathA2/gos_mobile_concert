import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';
import 'package:mobile_concert/generated/assets/fonts.gen.dart';
import 'package:mobile_concert/src/features/home/cubit/home_cubit.dart';
import 'package:mobile_concert/src/theme/values.dart';
import 'package:mobile_concert/widgets/post/social_post.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: context.read<HomeCubit>().syncData,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                title: const Text(
                  'Mobile Team',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.billabong,
                    fontSize: 32,
                  ),
                ),
                actions: [
                  _buildFavourist(),
                  const SizedBox(width: 16),
                  _buildMessager(),
                  const SizedBox(width: 16),
                ],
              ),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.listPost != current.listPost,
      builder: (context, state) {
        return SliverList.separated(
          itemCount: state.listPost.length,
          itemBuilder: (_, index) =>
              XSocialPost(postInfo: state.listPost[index]),
          separatorBuilder: (_, _) => const SizedBox(height: 4),
        );
      },
    );
  }

  Widget _buildMessager() {
    return SizedBox.square(
      dimension: 25,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Assets.svgs.icMessenger.svg(width: 24, height: 24),
          Positioned(
            top: -5,
            right: -8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                "5",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavourist() {
    return SizedBox.square(
      dimension: 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Assets.svgs.icFavourite.svg(width: 24, height: 24),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: BoxBorder.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
