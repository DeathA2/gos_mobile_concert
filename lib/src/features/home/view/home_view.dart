import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';
import 'package:mobile_concert/src/features/home/cubit/home_cubit.dart';
import 'package:mobile_concert/widgets/post/social_post.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Assets.svgs.icFavourite.svg(width: 24, height: 24),
            const SizedBox(width: 16),
            Assets.svgs.icMessenger.svg(width: 24, height: 24),
            const SizedBox(width: 16),
          ],
          title: const Text(
            'Mobile Team',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  previous.listPost != current.listPost,
              builder: (context, state) {
                return SliverList.separated(
                  itemCount: state.listPost.length,
                  itemBuilder: (_, index) =>
                      XSocialPost(postInfo: state.listPost[index]),
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
