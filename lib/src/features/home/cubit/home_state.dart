part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.listUser = const [],
    this.listPost = const [],
    this.likedPosts = const [],
  });

  final List<MUser> listUser;
  final List<MPost> listPost;
  final List<String> likedPosts;

  @override
  List<Object> get props => [listUser, listPost, likedPosts];

  HomeState copyWith({
    List<MUser>? listUser,
    List<MPost>? listPost,
    List<String>? likedPosts,
  }) {
    return HomeState(
      listUser: listUser ?? this.listUser,
      listPost: listPost ?? this.listPost,
      likedPosts: likedPosts ?? this.likedPosts,
    );
  }
}
