import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ozro_mobile/generated/assets.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    this.borderRadius = AppUtils.kBorderRadius8,
    required this.imageUrl,
    this.height = double.maxFinite,
    this.width = double.maxFinite,
    this.errorImageUrl,
    this.defaultWord,
    this.alignment,
    this.withDecoration = true,
    this.fit,
    this.margin = EdgeInsets.zero,
    this.iconBackColor,
    this.defaultWordStyle,
    this.imageColor,
  });

  final String imageUrl;
  final BorderRadius borderRadius;
  final double height;
  final double width;
  final String? errorImageUrl;
  final AlignmentGeometry? alignment;
  final bool withDecoration;
  final EdgeInsets margin;
  final String? defaultWord;
  final BoxFit? fit;
  final Color? iconBackColor;
  final TextStyle? defaultWordStyle;
  final Color? imageColor;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: fit ?? BoxFit.cover,
                  height: height,
                  width: width,
                  imageBuilder: (_, imageProvider) => DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: fit ?? BoxFit.cover,
                        // scale: 1.1,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                    child: CircularProgressIndicator.adaptive(
                      value: downloadProgress.progress,
                      strokeCap: StrokeCap.round,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colorScheme.primary,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => defaultWord != null && defaultWord!.isNotEmpty
                      ? Material(
                          color: iconBackColor ?? context.colorScheme.primary,
                          child: Center(
                            child: Text(
                              defaultWord?.isNotEmpty ?? false ? defaultWord![0].toUpperCase() : '',
                              style: defaultWordStyle ??
                                  context.textStyle.bodyBody.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: context.color.white,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Image(
                          image: const AssetImage(
                            Assets.pngEmptyImage,
                          ),
                          color: imageColor,
                        ),
                )
              : SizedBox(
                  height: height,
                  width: width,
                  child: defaultWord != null && defaultWord!.isNotEmpty
                      ? Material(
                          color: iconBackColor ?? context.colorScheme.primary,
                          child: Center(
                            child: Text(
                              defaultWord?.isNotEmpty ?? false ? defaultWord![0].toUpperCase() : '',
                              style: defaultWordStyle ??
                                  context.textStyle.bodyBody.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: context.color.white,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Image(
                          image: const AssetImage(
                            Assets.pngEmptyImage,
                          ),
                          color: imageColor,
                        ),
                ),
        ),
      );
}
