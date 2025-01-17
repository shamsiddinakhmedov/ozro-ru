import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/generated/assets.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/flash_bar_utils.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/comment_list_response.dart';
import 'package:ozro_mobile/src/data/models/main/home/products_list_response.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';
import 'package:ozro_mobile/src/injector_container.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/home/product_detail/product_detail_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/main/main_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/buttons/bottom_navigation_button.dart';
import 'package:ozro_mobile/src/presentation/components/image_network/custom_cached_network_image.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:ozro_mobile/src/presentation/components/sliver/sliver_list_separator_builder.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/product_detail_page/widgets/feedback_item_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

part 'widgets/proceed_order_product_widget.dart';

part 'widgets/product_info_widget.dart';

part 'widgets/product_comments_widget.dart';

part 'mixin/product_detail_mixin.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.args});

  final ProductDetailPageArgs args;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with _ProductDetailMixin {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          final favorite =
              context.read<ProductDetailBloc>().state.product?.favorite ??
                  false;
          context.pop<bool>(favorite);
          return true;
        },
        child: BlocListener<ProductDetailBloc, ProductDetailState>(
          listener: (context, state) {
            if (state.addCommentStatus.isSuccess) {
              commentController.clear();
            } else if (state.addCommentStatus.isError) {
              showFlashError(context: context, content: state.errorMessage);
            }
            if (state.productStatus.isError) {
              showFlashError(context: context, content: state.errorMessage);
            }
          },
          child: BlocSelector<ProductDetailBloc, ProductDetailState, bool>(
            selector: (state) =>
                state.feedbacksStatus.isLoading ||
                state.addCommentStatus.isLoading ||
                state.productStatus.isLoading,
            builder: (_, isLoading) => ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Scaffold(
                appBar: AppBar(
                  actions: [
                    BlocBuilder<ProductDetailBloc, ProductDetailState>(
                      builder: (_, state) {
                        debugLog(
                            'favorite product: ${state.product?.favorite}');
                        return IconButton(
                          onPressed: onFavorite,
                          icon: Icon(
                            (state.product?.favorite ?? false)
                                ? AppIcons.favoriteFilled
                                : AppIcons.favorite,
                            color: (state.product?.favorite ?? false)
                                ? context.colorScheme.error
                                : context.color.midGrey4,
                          ),
                        );
                      },
                    ),
                    BlocBuilder<ProductDetailBloc, ProductDetailState>(
                      builder: (_, state) => IconButton(
                        onPressed: () {
                          Share.share(
                            'https://ozro.ru/details?id=${widget.args.productId}',
                          );
                        },
                        icon: Image.asset(
                          'assets/png/ic_share.png',
                          width: 24,
                          height: 24,
                          color: context.color.midGrey4,
                        ),
                      ),
                    )
                  ],
                ),
                body: CustomScrollView(
                  controller: scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    BlocBuilder<ProductDetailBloc, ProductDetailState>(
                      buildWhen: (previous, current) =>
                          previous.feedbacks.length != current.feedbacks.length,
                      builder: (context, state) => ProductFeedbackInfoWidget(
                        key: ObjectKey(
                            'ProductInfoWidget ${widget.args.productId}'),
                        product: state.product,
                        showPopup: showPopup,
                        feedbacks: state.feedbacks,
                        animateToFeedbackId: widget.args.feedbackId,
                        overallPageController: overallPageController,
                      ),
                    ),
                    AppUtils.kSliverGap12,
                    BlocBuilder<ProductDetailBloc, ProductDetailState>(
                      builder: (context, state) => _ProceedOrderProductWidget(
                        key: ObjectKey(
                            'ProceedOrderProductWidget ${widget.args.productId}'),
                        product: state.product,
                      ),
                    ),
                    AppUtils.kSliverGap12,
                    DecoratedSliver(
                      key: ObjectKey(
                          'ProductCommentsTitleWidget ${widget.args.productId}'),
                      decoration: BoxDecoration(
                        borderRadius: AppUtils.kBorderRadiusOnlyTop12,
                        color: context.color.white,
                      ),
                      sliver: SliverPadding(
                        padding: AppUtils.kPaddingAll16,
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'Комментарии',
                            style: context.textStyle.regularBody.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<ProductDetailBloc, ProductDetailState>(
                      builder: (context, state) => _ProductCommentsWidget(
                        key: ObjectKey(
                            'ProductCommentsWidget ${widget.args.productId}'),
                        product: state.product,
                        onReplyPressed: focusNode.requestFocus,
                      ),
                    ),
                    BlocBuilder<ProductDetailBloc, ProductDetailState>(
                      builder: (_, state) => SliverAnimatedOpacity(
                        opacity:
                            state.commentsPaginationStatus.isLoading ? 1 : 0,
                        duration: animationDuration,
                        sliver: const SliverToBoxAdapter(
                          child: SafeArea(
                            minimum: AppUtils.kPaddingHorizontal16,
                            child: Column(
                              children: [
                                AppUtils.kGap8,
                                Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                floatingActionButton: ValueListenableBuilder(
                  valueListenable: isEndList,
                  builder: (_, value, ___) => Visibility(
                    visible: value,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: context.color.white,
                      shape: const CircleBorder(),
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: context.colorScheme.primary,
                        size: 28,
                      ),
                      onPressed: () {
                        scrollController.animateTo(0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                    ),
                  ),
                ),
                bottomNavigationBar:
                    BlocBuilder<ProductDetailBloc, ProductDetailState>(
                  builder: (_, state) => BottomNavigationButton(
                    withBottomViewInsets: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.reply != null)
                          Text(
                            state.reply?.user ?? '',
                            style: context.textStyle.regularSubheadline
                                .copyWith(
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.w600),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                // autofocus: true,
                                focusNode: focusNode,
                                controller: commentController,
                                hintText: 'Напишите комментарий',
                                onChanged: (value) {},
                                filled: true,
                                fillColor: context.color.lightGrey4,
                              ),
                            ),
                            AppUtils.kGap4,
                            CircleAvatar(
                              child: IconButton(
                                color: context.colorScheme.primary,
                                onPressed: () {
                                  if (commentController.text
                                      .trim()
                                      .isNotEmpty) {
                                    focusNode.unfocus();
                                    context.read<ProductDetailBloc>().add(
                                          ProductDetailAddCommentEvent(
                                            commentController.text,
                                          ),
                                        );
                                  }
                                },
                                icon: Icon(
                                  Icons.send_outlined,
                                  size: 26,
                                  color: context.colorScheme.surface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class ProductDetailPageArgs {
  const ProductDetailPageArgs({
    this.product,
    this.productId,
    this.feedbackId,
    this.withProductId = false,
  });

  final ProductsListResponse? product;
  final num? productId;
  final num? feedbackId;
  final bool withProductId;
}
