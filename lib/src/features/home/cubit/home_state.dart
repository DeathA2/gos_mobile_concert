part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.listUser = const [],
    this.listPost = const [],
    this.isLoggedIn = false,
  });

  final List<MUser> listUser;
  final List<MPost> listPost;
  final bool isLoggedIn;

  @override
  List<Object> get props => [listUser, listPost, isLoggedIn];

  HomeState copyWith({
    List<MUser>? listUser,
    List<MPost>? listPost,
    bool? isLoggedIn,
  }) {
    return HomeState(
      listUser: listUser ?? this.listUser,
      listPost: listPost ?? this.listPost,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
