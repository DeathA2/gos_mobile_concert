import 'package:mobile_concert/src/network/data/post/post_reference.dart';
import 'package:mobile_concert/src/network/data/post/post_repository.dart';
import 'package:mobile_concert/src/network/model/common/result.dart';
import 'package:mobile_concert/src/network/model/post.dart';

class PostRepositoryImpl extends PostRepository {
  final postsRef = PostReference();

  @override
  Future<MResult<List<MPost>>> getAllPosts() {
    return postsRef.getPosts();
  }
}
