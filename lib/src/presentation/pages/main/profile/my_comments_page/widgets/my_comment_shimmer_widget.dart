import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class MyCommentShimmerWidget extends StatelessWidget {
  const MyCommentShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: context.kSize.width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.color.white,
            borderRadius: AppUtils.kBorderRadius8,
            // border: Border.all(
            //   color: context.color.lightGrey2,
            // ),
          ),
          child: Shimmer.fromColors(
            highlightColor: context.color.white,
            baseColor: context.color.lightGrey2,
            period: const Duration(seconds: 2),
            child: Padding(
              padding: AppUtils.kPaddingAll6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.color.white,
                      borderRadius: AppUtils.kBorderRadius4,
                    ),
                    child: SizedBox(
                      height: 12,
                      width: context.kSize.width,
                    ),
                  ),
                  AppUtils.kGap4,
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.color.white,
                      borderRadius: AppUtils.kBorderRadius4,
                    ),
                    child: SizedBox(
                      height: 12,
                      width: context.kSize.width,
                    ),
                  ),
                  AppUtils.kGap4,
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.color.white,
                      borderRadius: AppUtils.kBorderRadius4,
                    ),
                    child: SizedBox(
                      height: 12,
                      width: context.kSize.width,
                    ),
                  ),
                  AppUtils.kGap4,
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.color.white,
                      borderRadius: AppUtils.kBorderRadius4,
                    ),
                    child: SizedBox(
                      height: 12,
                      width: context.kSize.width / 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
