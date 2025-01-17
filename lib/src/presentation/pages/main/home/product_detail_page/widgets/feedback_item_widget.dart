import 'package:flutter/material.dart';
import 'package:ozro_mobile/generated/assets.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/comment_list_response.dart';
import 'package:ozro_mobile/src/presentation/components/image_network/custom_cached_network_image.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/product_detail_page/widgets/better_player_widget.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/product_detail_page/widgets/video_player_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductFeedbackItemWidget extends StatefulWidget {
  const ProductFeedbackItemWidget({
    super.key,
    required this.feedback,
    required this.showPopup,
    required this.index,
    required this.length,
    required this.pageIndexForImage,
    required this.overallPageController,
    required this.link,
    required this.productName,
  });

  final CommentListResponse feedback;
  final ValueNotifier<bool> showPopup;
  final int index;
  final int length;
  final ValueNotifier<int> pageIndexForImage;
  final PageController overallPageController;
  final String link;
  final String productName;

  @override
  State<ProductFeedbackItemWidget> createState() =>
      _ProductFeedbackItemWidgetState();
}

class _ProductFeedbackItemWidgetState extends State<ProductFeedbackItemWidget> {
  late final PageController pageController;

  @override
  void initState() {
    debugLog('ProductFeedbackItemWidget initState');
    pageController = PageController();
    super.initState();
    debugLog(
        'widget.feedback.files.length----> ${widget.feedback.files?[0].type}');
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 8,
            child: SizedBox(
              height: context.kSize.height * 0.6,
              child: widget.feedback.files?.isNotEmpty ?? false
                  ? Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.showPopup.value = !widget.showPopup.value;
                          },
                          child: PageView(
                            key: ObjectKey('PageView view ${widget.index}'),
                            controller: pageController,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (value) {
                              debugLog('page value $value');
                              widget.pageIndexForImage.value = value;
                              debugLog(
                                  'pageIndex.value ${widget.pageIndexForImage.value}');

                              // if (value == widget.feedback.files.length && widget.index != widget.length - 1) {
                              //   widget.pageIndexForImage.value = 0;
                              //   widget.overallPageController.animateToPage(
                              //     widget.index + 1,
                              //     duration: const Duration(milliseconds: 200),
                              //     curve: Curves.linear,
                              //   );
                              // }
                              // else if (value == 0 && overallPageController.page != 0) {
                              //   overallPageController.animateToPage(
                              //     index - 1,
                              //     duration: const Duration(milliseconds: 200),
                              //     curve: Curves.linear,
                              //   );
                              // }
                            },
                            children: [
                              ...List.generate(
                                  widget.feedback.files?.length ?? 0,
                                  (i) => (widget.feedback.files?[i].link ?? '')
                                          .isEmpty
                                      ? const SizedBox()
                                      : widget.feedback.files?[i].type ==
                                              'IMAGE'
                                          ? CustomCachedNetworkImage(
                                              height:
                                                  context.kSize.height * 0.6,
                                              imageUrl: widget.feedback
                                                      .files?[i].link ??
                                                  '',
                                              fit: BoxFit.contain,
                                              borderRadius:
                                                  AppUtils.kBorderRadius0,
                                              imageColor: context.color.white,
                                            )
                                          : widget.feedback.files?[i].type ==
                                                  'VIDEO'
                                              ? !(widget.feedback.files?[i]
                                                          .stream ??
                                                      false)
                                                  ? VideoPlayerWithNetworkUrlWidget(
                                                      videoLink: widget.feedback
                                                              .files?[i].link ??
                                                          '')
                                                  // : BetterPlayerWidget(
                                                  //     videoLink: widget.feedback
                                                  //             .files?[i].link ??
                                                  //         '',
                                                  //   )
                                                  : const SizedBox()
                                              : const SizedBox()),
                              // if (widget.index != widget.length - 1) const SizedBox()
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: widget.showPopup,
                          builder: (_, value, __) {
                            if (value) {
                              return Align(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipPath(
                                      clipper: TriangleClipper(),
                                      child: Container(
                                        width: 25,
                                        height: 40,
                                        color: context.color.black
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    Container(
                                      width: context.kSize.width * 0.6,
                                      height: 40,
                                      padding: AppUtils.kPaddingAll6,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                                right: Radius.circular(2)),
                                        color: context.color.black
                                            .withOpacity(0.7),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (widget.link.isNotEmpty) {
                                            launchUrl(Uri.parse(widget.link));
                                            widget.showPopup.value = false;
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Image(
                                                image:
                                                    AssetImage(Assets.pngBag)),
                                            AppUtils.kGap4,
                                            Expanded(
                                              child: Text(
                                                widget.productName,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.textStyle
                                                    .regularSubheadline
                                                    .copyWith(
                                                        color: context
                                                            .colorScheme
                                                            .surface),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    )
                  : CustomCachedNetworkImage(
                      imageColor: context.color.white,
                      imageUrl: '',
                      fit: BoxFit.fill,
                      borderRadius: AppUtils.kBorderRadius0,
                    ),
            ),
          ),
          AppUtils.kGap32,
          ValueListenableBuilder(
            valueListenable: widget.pageIndexForImage,
            builder: (_, value, __) => Padding(
              padding: AppUtils.kPaddingHorizontal8,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.feedback.files?.length ?? 0,
                    (index) => Padding(
                      padding: AppUtils.kPaddingAll4,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: index == value
                            ? context.colorScheme.primary
                            : context.color.lightGrey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AppUtils.kGap12,
          Flexible(
            flex: 3,
            child: Padding(
              padding: AppUtils.kPaddingAll16,
              child: Text(
                widget.feedback.content ?? '',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
                style: context.textStyle.regularBody.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.color.darkGrey3,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      );
}

// Clipper to create the triangle shape
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
