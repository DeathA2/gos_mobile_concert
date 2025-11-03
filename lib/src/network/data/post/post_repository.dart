import 'package:mobile_concert/src/network/model/common/result.dart';
import 'package:mobile_concert/src/network/model/post.dart';

abstract class PostRepository {
  Future<MResult<List<MPost>>> getAllPosts();
}
