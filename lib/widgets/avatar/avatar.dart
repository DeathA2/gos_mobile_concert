import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';
import 'package:mobile_concert/src/theme/colors.dart';
import 'package:mobile_concert/src/theme/values.dart';
import 'package:mobile_concert/src/utils/utils.dart';

class XAvatar extends StatefulWidget {
  final String? url;
  final String? firstName;
  final String? lastName;
  final bool isEditable;
  final VoidCallback? onEdit;
  final TextStyle? textStyle;
  final double? borderWidth;
  final double? imageSize;
  final List<BoxShadow>? boxShadow;
  const XAvatar({
    super.key,
    this.url,
    this.firstName,
    this.lastName,
    this.isEditable = false,
    this.onEdit,
    this.textStyle,
    this.borderWidth,
    this.imageSize,
    this.boxShadow,
  });

  @override
  State<XAvatar> createState() => _XAvatarState();
}

class _XAvatarState extends State<XAvatar> {
  bool isValidUrl(String? url) {
    if (url?.isEmpty ?? true) {
      return false;
    }
    return true;
  }

  String getNameAvatar(String? firstName, String? lastName) {
    String firstCharFirstName = '';
    String firstCharLastName = '';
    if (firstName != null && firstName != '') {
      firstCharFirstName = firstName[0];
    }
    if (lastName != null && lastName != '') {
      firstCharLastName = lastName[0];
    }
    return '$firstCharFirstName$firstCharLastName'.toUpperCase();
  }

  Widget _renderImage(String? url) {
    if (isNullOrEmpty(url)) {
      return _renderDefaultImage();
    }
    return SizedBox(
      width: widget.imageSize ?? AppSizes.s70,
      height: widget.imageSize ?? AppSizes.s70,
      child: CachedNetworkImage(
        imageUrl: url ?? '',
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              borderRadius: BorderRadius.all(
                Radius.circular((widget.imageSize ?? AppSizes.s70) / 2),
              ),
              border: Border.all(
                color: AppColors.primary,
                width: widget.borderWidth ?? AppBorderWidth.w5,
              ),
              boxShadow: widget.boxShadow,
            ),
          );
        },
        placeholder: (context, url) {
          return _renderDefaultImage();
        },
        errorWidget: (context, url, error) {
          return _renderDefaultImage();
        },
      ),
    );
  }

  Widget _renderDefaultImage() {
    return Container(
      width: widget.imageSize ?? AppSizes.s70,
      height: widget.imageSize ?? AppSizes.s70,
      decoration: BoxDecoration(
        color: AppColors.white,
        image: null,
        borderRadius: BorderRadius.all(
          Radius.circular((widget.imageSize ?? AppSizes.s70) / 2),
        ),
        border: Border.all(
          color: AppColors.black2,
          width: widget.borderWidth ?? AppBorderWidth.w5,
        ),
        boxShadow: widget.boxShadow,
      ),
      child: Center(
        // child: Text(
        //   getNameAvatar(widget.firstName, widget.lastName),
        //   style: widget.textStyle ?? AppStyles.titleLarge,
        // ),
        child: Assets.svgs.icUserDefault.svg(
          width: widget.imageSize ?? AppSizes.s70,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isValidUrl(widget.url)
            ? _renderImage(widget.url)
            : _renderDefaultImage(),
        // widget.isEditable
        //     ? Positioned(
        //         bottom: 0,
        //         right: 0,
        //         child: IconButton(
        //           onPressed: () {
        //             widget.onEdit?.call();
        //           },
        //           icon: SvgPicture.asset(ImagesApp.editAvatar),
        //           alignment: Alignment.bottomRight,
        //           padding: const EdgeInsets.only(
        //             left: PaddingApp.p10,
        //             top: PaddingApp.p10,
        //           ),
        //           constraints: const BoxConstraints(
        //             minWidth: SizeApp.s24,
        //             minHeight: SizeApp.s24,
        //           ),
        //           splashColor: Colors.transparent,
        //           highlightColor: Colors.transparent,
        //         ),
        //       )
        //     : const SizedBox.shrink(),
      ],
    );
  }
}
