import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_concert/src/network/firebase/base_collection.dart';
import 'package:mobile_concert/src/network/model/common/result.dart';
import 'package:mobile_concert/src/network/model/post.dart';

class PostReference extends BaseCollectionReference<MPost> {
  PostReference()
    : super(
        FirebaseFirestore.instance
            .collection('posts')
            .withConverter<MPost>(
              fromFirestore: (snapshot, _) => MPost.fromSnapshot(snapshot),
              toFirestore: (post, _) => post.toMap(),
            ),
        getObjectId: (e) => e.id,
        setObjectId: (e, id) => e.copyWith(id: id),
      );

  Future<MResult<List<MPost>>> getPosts() async {
    try {
      final QuerySnapshot<MPost> query = await ref.get().timeout(
        const Duration(seconds: 10),
      );
      final docs = query.docs.map((e) => e.data()).toList();
      return MResult.success(docs);
    } catch (e) {
      return MResult.exception(e);
    }
  }
}
