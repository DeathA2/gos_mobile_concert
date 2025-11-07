import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_concert/src/network/firebase/base_collection.dart';
import 'package:mobile_concert/src/network/model/common/result.dart';
import 'package:mobile_concert/src/network/model/user.dart';

class UserReference extends BaseCollectionReference<MUser> {
  UserReference()
    : super(
        FirebaseFirestore.instance
            .collection('users')
            .withConverter<MUser>(
              fromFirestore: (snapshot, _) => MUser.fromSnapshot(snapshot),
              toFirestore: (user, _) => user.toMap(),
            ),
        getObjectId: (e) => e.id,
        setObjectId: (e, id) => e.copyWith(id: id),
      );

  Future<MResult<List<MUser>>> getUsers() async {
    try {
      final QuerySnapshot<MUser> query = await ref.get().timeout(
        const Duration(seconds: 20),
      );
      final docs = query.docs.map((e) => e.data()).toList();
      return MResult.success(docs);
    } catch (e) {
      return MResult.exception(e);
    }
  }
}
