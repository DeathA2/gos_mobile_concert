import 'package:mobile_concert/src/network/model/common/result.dart';
import 'package:mobile_concert/src/network/model/user.dart';

abstract class UserRepository {
  Future<MResult<List<MUser>>> getAllUser();
}
