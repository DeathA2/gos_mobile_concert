// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:lottie/lottie.dart' as _lottie;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsLottiesGen {
  const $AssetsLottiesGen();

  /// File path: assets/lotties/location-animation.json
  LottieGenImage get locationAnimation =>
      const LottieGenImage('assets/lotties/location-animation.json');

  /// File path: assets/lotties/rocket.json
  LottieGenImage get rocket =>
      const LottieGenImage('assets/lotties/rocket.json');

  /// List of all assets
  List<LottieGenImage> get values => [locationAnimation, rocket];
}

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// File path: assets/svgs/empty_photo.svg
  SvgGenImage get emptyPhoto =>
      const SvgGenImage('assets/svgs/empty_photo.svg');

  /// File path: assets/svgs/ic_apple.svg
  SvgGenImage get icApple => const SvgGenImage('assets/svgs/ic_apple.svg');

  /// File path: assets/svgs/ic_facebook.svg
  SvgGenImage get icFacebook =>
      const SvgGenImage('assets/svgs/ic_facebook.svg');

  /// File path: assets/svgs/ic_google.svg
  SvgGenImage get icGoogle => const SvgGenImage('assets/svgs/ic_google.svg');

  /// File path: assets/svgs/ic_user_default.svg
  SvgGenImage get icUserDefault =>
      const SvgGenImage('assets/svgs/ic_user_default.svg');

  /// File path: assets/svgs/state_empty.svg
  SvgGenImage get stateEmpty =>
      const SvgGenImage('assets/svgs/state_empty.svg');

  /// File path: assets/svgs/state_empty_map.svg
  SvgGenImage get stateEmptyMap =>
      const SvgGenImage('assets/svgs/state_empty_map.svg');

  /// File path: assets/svgs/state_empty_notification.svg
  SvgGenImage get stateEmptyNotification =>
      const SvgGenImage('assets/svgs/state_empty_notification.svg');

  /// File path: assets/svgs/state_error.svg
  SvgGenImage get stateError =>
      const SvgGenImage('assets/svgs/state_error.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    emptyPhoto,
    icApple,
    icFacebook,
    icGoogle,
    icUserDefault,
    stateEmpty,
    stateEmptyMap,
    stateEmptyNotification,
    stateError,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsLottiesGen lotties = $AssetsLottiesGen();
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class LottieGenImage {
  const LottieGenImage(this._assetName, {this.flavors = const {}});

  final String _assetName;
  final Set<String> flavors;

  _lottie.LottieBuilder lottie({
    Animation<double>? controller,
    bool? animate,
    _lottie.FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    _lottie.LottieDelegates? delegates,
    _lottie.LottieOptions? options,
    void Function(_lottie.LottieComposition)? onLoaded,
    _lottie.LottieImageProviderFactory? imageProviderFactory,
    Key? key,
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, _lottie.LottieComposition?)?
    frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    String? package,
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
    _lottie.LottieDecoder? decoder,
    _lottie.RenderCache? renderCache,
    bool? backgroundLoading,
  }) {
    return _lottie.Lottie.asset(
      _assetName,
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
      filterQuality: filterQuality,
      onWarning: onWarning,
      decoder: decoder,
      renderCache: renderCache,
      backgroundLoading: backgroundLoading,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
