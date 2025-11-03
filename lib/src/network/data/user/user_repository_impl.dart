import 'package:mobile_concert/src/network/data/user/user_reference.dart';
import 'package:mobile_concert/src/network/data/user/user_repository.dart';
import 'package:mobile_concert/src/network/model/common/result.dart';
import 'package:mobile_concert/src/network/model/user.dart';

class UserRepositoryImpl extends UserRepository {
  final usersRef = UserReference();

  @override
  Future<MResult<List<MUser>>> getAllUser() {
    return usersRef.getUsers();
  }
}
