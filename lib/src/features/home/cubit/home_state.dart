part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({this.listUser = const [], this.listPost = const []});

  final List<MUser> listUser;
  final List<MPost> listPost;

  @override
  List<Object> get props => [listUser, listPost];

  HomeState copyWith({List<MUser>? listUser, List<MPost>? listPost}) {
    return HomeState(
      listUser: listUser ?? this.listUser,
      listPost: listPost ?? this.listPost,
    );
  }
}
