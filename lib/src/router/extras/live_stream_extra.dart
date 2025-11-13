import 'package:mobile_concert/src/network/model/post.dart';

class LiveStreamExtra {
  LiveStreamExtra(this.post, this.messages);
  final MPost post;
  final List<String> messages;
}
