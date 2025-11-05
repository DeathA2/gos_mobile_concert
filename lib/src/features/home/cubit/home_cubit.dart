import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_concert/src/network/data/post/post_repository_impl.dart';
import 'package:mobile_concert/src/network/data/user/user_repository_impl.dart';
import 'package:mobile_concert/src/network/model/post.dart';
import 'package:mobile_concert/src/network/model/user.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState()) {
    _syncData();
  }
  final userRepo = UserRepositoryImpl();
  final postRepo = PostRepositoryImpl();

  StreamSubscription<QuerySnapshot<MPost>>? listenPostStream;

  Future<void> _syncData() async {
    await _getListUser();
    _listenPostsChange();
  }

  Future<void> _getListUser() async {
    final listUser = await userRepo.getAllUser();
    emit(state.copyWith(listUser: listUser.data ?? []));
  }

  void _listenPostsChange() {
    listenPostStream = postRepo.getStreamAllPost().listen((snapshot) {
      final updatedPosts = snapshot.docs.map((doc) {
        final post = doc.data();
        final ownerUser = state.listUser.firstWhere(
          (user) => user.id == post.owner,
          orElse: () => MUser(id: '', name: 'Unknown', avatar: ''),
        );
        return post.copyWith(ownerUser: ownerUser);
      }).toList();
      emit(state.copyWith(listPost: updatedPosts));
    });
  }

  @override
  Future<void> close() {
    listenPostStream?.cancel();
    return super.close();
  }
}
