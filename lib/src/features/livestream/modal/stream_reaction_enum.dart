import 'package:mobile_concert/generated/assets/assets.gen.dart';

enum StreamReaction {
  love,
  like,
  gift;

  LottieGenImage getLottieAnimation() {
    switch (this) {
      case love:
        return Assets.lotties.heartAnimation;
      case like:
        return Assets.lotties.likeAnimation;
      case gift:
        return Assets.lotties.giftAnimation;
    }
  }
}
