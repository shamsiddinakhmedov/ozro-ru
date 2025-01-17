part of '../product_detail_page.dart';

mixin _ProductDetailMixin on State<ProductDetailPage> {
  late final ScrollController scrollController;
  late final TextEditingController commentController = TextEditingController();
  final PageController overallPageController = PageController();
  final ValueNotifier<bool> isEndList = ValueNotifier<bool>(false);
  final ValueNotifier<bool> showPopup = ValueNotifier<bool>(false);
  late final FocusNode focusNode;

  @override
  void initState() {
    // debugLog('product source: ${widget.product.variants.firstOrNull?.sourceId}');
    scrollController = ScrollController()..addListener(_onScroll);
    context.read<ProductDetailBloc>().add(
          ProductDetailInitialEvent(
            product: widget.args.product,
            productId: widget.args.productId,
            withProductId: widget.args.withProductId,
            onFeedbacksLoaded: _animateToFeedback,
          ),
        );
    focusNode = FocusNode()..addListener(_focusListener);
    // _initPopup();
    super.initState();
  }

  Future<void> _animateToFeedback() async {
    if (widget.args.feedbackId != null) {
      // animateFeedbackIsLoading.value = true;
      await Future<void>.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      final feedbackIndex = context
          .read<ProductDetailBloc>()
          .state
          .feedbacks
          .indexWhere((element) => element.id == widget.args.feedbackId);
      if (feedbackIndex != -1) {
        if (overallPageController.hasClients) {
          await overallPageController.animateToPage(
            feedbackIndex,
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
          );
        }
      }
      // animateFeedbackIsLoading.value = false;
    }
  }

  void _focusListener() {
    if (focusNode.hasFocus) {
      if (!localSource.hasProfile) {
        focusNode.unfocus();
        context.pushNamed(Routes.auth, extra: true);
      }
    }
  }

  // /// [_initPopup] to auto show popup after a few seconds
  // Future<void> _initPopup() async {
  //   await Future<void>.delayed(
  //     const Duration(seconds: 2),
  //     () {
  //       showPopup.value = true;
  //     },
  //   );
  // }

  void _onScroll() {
    if (scrollController.offset > 50) {
      isEndList.value = true;
    } else if (isEndList.value) {
      isEndList.value = false;
    }
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll == currentScroll && context.read<ProductDetailBloc>().state.commentsPaginationStatus.isNotDone) {
      context.read<ProductDetailBloc>().add(
            const ProductDetailFetchCommentsEvent(isRefresh: false),
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
    scrollController.dispose();
    overallPageController.dispose();
    // focusNode
    //   ..removeListener(_focusListener)
    //   ..dispose();
  }

  Future<void> onFavorite() async {
    if (localSource.hasProfile) {
      final result = await sl<MainRepository>().addToFavorites(productId: widget.args.productId);
      result.fold(
        (l) {},
        (r) {
          context.read<ProductDetailBloc>().add(const ProductDetailAddToFavoritesEvent());
          context.read<MainBloc>().add(const MainFetchFavoriteProducts());
        },
      );
    } else {
      await context.pushNamed(Routes.auth, extra: true);
    }
  }
}
