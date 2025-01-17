part of '../product_detail_page.dart';

class ProductFeedbackInfoWidget extends StatefulWidget {
  const ProductFeedbackInfoWidget({
    super.key,
    required this.product,
    required this.showPopup,
    required this.feedbacks,
    this.animateToFeedbackId,
    required this.overallPageController,
  });

  final ProductsListResponse? product;
  final List<CommentListResponse> feedbacks;
  final ValueNotifier<bool> showPopup;
  final num? animateToFeedbackId;
  final PageController overallPageController;

  @override
  State<ProductFeedbackInfoWidget> createState() => _ProductFeedbackInfoWidgetState();
}

class _ProductFeedbackInfoWidgetState extends State<ProductFeedbackInfoWidget>  {
  // late final PageController overallPageController;
  ValueNotifier<bool> animateFeedbackIsLoading = ValueNotifier(false);
  final ValueNotifier<int> pageIndexForImage = ValueNotifier(0);

  @override
  void initState() {
    debugLog('_ProductFeedbackInfoWidget initState');
    // ..addListener(_onScroll);
    // ..addListener(
    //   () {
    //     // if (pageController.offset == context.kSize.width) {
    //     //   final filesLength = widget.feedbacks[overallPageController.page!.toInt()].files.length;
    //     //   final last = (pageController.page!.toInt()) == filesLength - 1 ? 1 + filesLength : filesLength - 1;
    //     //   if (last == filesLength) {
    //     //     return;
    //     //   }
    //     //   debugLog('pageController.offset == context.kSize.width');
    //     //   debugLog('filesLength: $filesLength');
    //     //   if (pageController.page!.toInt() == pageController.page) {
    //     //     debugLog('nextPage');
    //     //     overallPageController.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
    //     //   }
    //     // }
    //
    //     /// debugLog all pageController args
    //     // debugLog('pageController: ${pageController.page}');
    //     // // pageIndex.value = pageController.page!.toInt();
    //     // debugLog('pageController.onAttach: ${pageController.onAttach}');
    //     // debugLog('pageController.onDetach: ${pageController.onDetach}');
    //     // debugLog('pageController.position: ${pageController.position.pixels}');
    //     // debugLog('pageController.offset: ${pageController.offset}');
    //     // debugLog('context.ksize.width ${context.kSize.width}');
    //   },
    // );
    // overallPageController = PageController();
    // _animateToFeedback();

    super.initState();
  }

  // void _onScroll() {
  //   final maxScroll = scrollController.position.maxScrollExtent;
  //   final currentScroll = scrollController.position.pixels;
  //   if (maxScroll == currentScroll && context.read<ProductDetailBloc>().state.feedbacksPaginationStatus.isNotDone) {
  //     context.read<ProductDetailBloc>().add(
  //           const ProductDetailFetchFeedbacksEvent(isRefresh: false),
  //         );
  //   }
  // }

  // Future<void> _animateToFeedback() async {
  //   if (!mounted) return;
  //   if (widget.animateToFeedbackId != null) {
  //     animateFeedbackIsLoading.value = true;
  //     await Future<void>.delayed(const Duration(seconds: 2));
  //     final feedbackIndex = widget.feedbacks.indexWhere((element) => element.id == widget.animateToFeedbackId);
  //     if (feedbackIndex != -1) {
  //       if (overallPageController.hasClients) {
  //         await overallPageController.animateToPage(
  //           feedbackIndex,
  //           duration: const Duration(milliseconds: 200),
  //           curve: Curves.linear,
  //         );
  //       }
  //     }
  //     animateFeedbackIsLoading.value = false;
  //   }
  // }

  @override
  void dispose() {
    // overallPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DecoratedSliver(
        decoration: BoxDecoration(
          borderRadius: AppUtils.kBorderRadius12,
          color: context.color.white,
        ),
        sliver: SliverToBoxAdapter(
          child: SizedBox(
            height: context.kSize.height * 0.7,
            width: double.infinity,
            child: ValueListenableBuilder(
              valueListenable: animateFeedbackIsLoading,
              builder: (_, value, __) => ModalProgressHUD(
                inAsyncCall: value,
                child: PageView.builder(
                  key: widget.key,
                  controller: widget.overallPageController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: widget.feedbacks.length,
                  onPageChanged: (value) {
                    context.read<ProductDetailBloc>().add(
                          ProductDetailChangeCurrentFeedbackEvent(widget.feedbacks[value]),
                        );
                    pageIndexForImage.value = 0;
                  },
                  itemBuilder: (_, index) => ProductFeedbackItemWidget(
                    key: ObjectKey('ProductFeedbackItemWidget ${widget.feedbacks[index].id}'),
                    feedback: widget.feedbacks[index],
                    showPopup: widget.showPopup,
                    index: index,
                    length: widget.feedbacks.length,
                    pageIndexForImage: pageIndexForImage,
                    overallPageController: widget.overallPageController,
                    link: widget.product?.link ?? '',
                    productName: widget.product?.title ?? '',
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class RightTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87 // Adjust color to match the image
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height / 4) // Bottom-left point
      ..lineTo(size.width, size.height) // Bottom-right point
      ..lineTo(size.width, 0) // Top-left point
      ..close(); // Close the path to form a triangle

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
