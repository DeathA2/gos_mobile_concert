import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPost({
    required int id,
    required String content,
    required String mediaUrl,
    required String owner,
    required String streamHostId,
    required int streamRoom,
  }) async {
    await _db.runTransaction((transaction) async {
      final newPostRef = _db.collection('posts').doc(id.toString());

      transaction.set(newPostRef, {
        "content": content,
        "created_at": DateTime.now(),
        "is_stream": false,
        "medias": [mediaUrl],
        "owner": owner,
        "stream_host_id": streamHostId,
        "stream_room": streamRoom,
      });
    });
  }
}
