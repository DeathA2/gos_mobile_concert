import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_concert/src/network/data/post/post_repository_impl.dart';
import 'package:mobile_concert/src/network/data/user/user_repository_impl.dart';
import 'package:mobile_concert/src/network/model/post.dart';
import 'package:mobile_concert/src/network/model/user.dart';
import 'package:mobile_concert/src/utils/app_store.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState()) {
    syncData();
    _login();
  }
  final userRepo = UserRepositoryImpl();
  final postRepo = PostRepositoryImpl();

  Future<void> syncData() async {
    await _getListUser();
    _getListPost();
  }

  final _userId = 'philip_2';

  void _login() async {
    AppStore.userId = _userId;
  }

  Future<void> _getListUser() async {
    final listUser = await userRepo.getAllUser();
    emit(state.copyWith(listUser: listUser.data ?? []));
  }

  Future<void> _getListPost() async {
    final listPost = await postRepo.getAllPosts();
    final newPost = listPost.data?.map((post) {
      final ownerUser = state.listUser.firstWhere(
        (user) => user.id == post.owner,
        orElse: () => MUser(id: '', name: 'Unknown', avatar: ''),
      );
      return post.copyWith(ownerUser: ownerUser);
    }).toList();
    emit(state.copyWith(listPost: newPost ?? []));
  }

  bool alreadyLikedPost(String postId) {
    return state.likedPosts.contains(postId);
  }

  void updateLikedPost(String postId, {bool forceLike = false}) {
    final likedPosts = [...state.likedPosts];
    final alreadyLiked = alreadyLikedPost(postId);

    if (alreadyLiked && forceLike) return;

    final shouldLike = forceLike || !alreadyLiked;

    if (shouldLike) {
      likedPosts.add(postId);
    } else {
      likedPosts.remove(postId);
    }

    emit(state.copyWith(likedPosts: likedPosts));
  }
}
