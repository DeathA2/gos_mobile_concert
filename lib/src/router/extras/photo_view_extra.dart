import 'package:mobile_concert/src/network/model/post.dart';

class PhotoViewExtra {
  PhotoViewExtra(
    this.galleryItems, {
    this.initialIndex = 0,
    required this.infor,
  });
  final int initialIndex;
  final List<String> galleryItems;
  final MPost infor;
}
