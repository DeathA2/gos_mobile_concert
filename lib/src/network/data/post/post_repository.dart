import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_concert/src/network/model/common/result.dart';
import 'package:mobile_concert/src/network/model/post.dart';

abstract class PostRepository {
  Future<MResult<List<MPost>>> getAllPosts();
  Stream<QuerySnapshot<MPost>> getStreamAllPost();
  Stream<DocumentSnapshot<MPost>> getStreamPostById(String postId);
}
