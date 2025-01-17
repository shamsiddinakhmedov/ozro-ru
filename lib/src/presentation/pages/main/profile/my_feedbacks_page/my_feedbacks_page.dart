import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/comment_list_response.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/profile/my_feedbacks/my_feedbacks_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/custom_popup_menu_widget/custom_popup_menu_widget.dart';
import 'package:ozro_mobile/src/presentation/components/dialogs/custom_dialog.dart';
import 'package:ozro_mobile/src/presentation/components/image_network/custom_cached_network_image.dart';
import 'package:ozro_mobile/src/presentation/components/sliver/sliver_list_separator_builder.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/product_detail_page/product_detail_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/my_comments_page/widgets/my_comment_shimmer_widget.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/my_feedbacks_page/edit_my_comment/edit_my_comment_page.dart';

part 'widgets/my_feedback_item_widget.dart';

class MyFeedbacksPage extends StatefulWidget {
  const MyFeedbacksPage({super.key});

  @override
  State<MyFeedbacksPage> createState() => _MyFeedbacksPageState();
}

class _MyFeedbacksPageState extends State<MyFeedbacksPage> {
  late final ScrollController scrollController;
  final ValueNotifier<bool> isEndList = ValueNotifier<bool>(false);

  @override
  void initState() {
    scrollController = ScrollController()..addListener(_onScroll);
    context.read<MyFeedbacksBloc>().add(const MyFeedbacksFetchEvent());
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.offset > 60) {
      isEndList.value = true;
    } else if (isEndList.value) {
      isEndList.value = false;
    }
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll == currentScroll && context.read<MyFeedbacksBloc>().state.paginationStatus.isNotDone) {
      context.read<MyFeedbacksBloc>().add(
            const MyFeedbacksFetchEvent(
              isRefresh: false,
            ),
          );
    }
  }

  Future<void> _onRefresh({bool withDuration = true}) async {
    await Future.delayed(
      Duration(seconds: withDuration ? 2 : 0),
      () {
        if (mounted) {
          context.read<MyFeedbacksBloc>().add(const MyFeedbacksFetchEvent());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Мои отзывы'),
          shape: const RoundedRectangleBorder(borderRadius: AppUtils.kBorderRadiusOnlyBottom16),
        ),
        body: BlocBuilder<MyFeedbacksBloc, MyFeedbacksState>(
          builder: (_, state) => RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                AppUtils.kSliverGap12,
                if(state.feedbacksStatus.isLoading)
                  SliverListSeparatorBuilder(
                    padding: AppUtils.kPaddingAll12,
                    itemCount: 20,
                    itemBuilder: (_, index) => const MyCommentShimmerWidget(),
                    separatorBuilder: (_, index) => AppUtils.kGap12,
                  ),
                if (state.feedbacks.isNotEmpty) ...[
                  SliverListSeparatorBuilder(
                    padding: AppUtils.kPaddingAll12,
                    itemCount: state.feedbacks.length,
                    itemBuilder: (_, index) => _MyFeedbackItemWidget(
                      key: ObjectKey('_MyFeedbackItemWidget feedback_${state.feedbacks[index].id}'),
                      feedback: state.feedbacks[index],
                      onDelete: () async {
                        await showCustomDialog(
                          context: context,
                          title: 'Удаление отзыва',
                          content: 'Вы уверены? Это действие нельзя будет отменить',
                          defaultActionText: 'Да',
                          cancelActionText: 'Нет',
                          contentPadding: AppUtils.kPaddingVertical16,
                          contentTextStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          isDefaultActionDisabled: true,
                        ).then(
                          (value) async {
                            if (value is bool && value && context.mounted) {
                              context.read<MyFeedbacksBloc>().add(
                                    MyFeedbacksDeleteEvent(
                                      feedback: state.feedbacks[index],
                                      index: index,
                                    ),
                                  );
                            }
                          },
                        );
                      },
                      onEdit: () {
                        context.pushNamed(
                          Routes.editMyComment,
                          extra: EditMyCommentArgs(
                            comment: state.feedbacks[index],
                            fromComment: false,
                          ),
                        )
                            .then(
                          (value) {
                            if (value is bool && value && context.mounted) {
                              _onRefresh(withDuration: false);
                            }
                          },
                        );
                      },
                      onShowThisFeedback: () {
                        context.pushNamed<bool>(
                          Routes.productDetail,
                          extra: ProductDetailPageArgs(
                            productId: state.feedbacks[index].product,
                            withProductId: true,
                            feedbackId: state.feedbacks[index].id,
                          ),
                        );
                      },
                    ),
                    separatorBuilder: (_, index) => AppUtils.kGap12,
                  ),
                  SliverAnimatedOpacity(
                    opacity: state.paginationStatus.isLoading ? 1 : 0,
                    duration: animationDuration,
                    sliver: const SliverToBoxAdapter(
                      child: SafeArea(
                        minimum: AppUtils.kPaddingHorizontal16,
                        child: Column(
                          children: [
                            AppUtils.kGap8,
                            Center(
                              child: CircularProgressIndicator.adaptive(strokeCap: StrokeCap.round),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                if (state.feedbacks.isEmpty && !state.feedbacksStatus.isLoading)
                  DecoratedSliver(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: AppUtils.kBorderRadius16,
                    ),
                    sliver: SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const Image(
                            //   image: AssetImage(Assets.pngCommentaryNotFound),
                            // ),
                            // AppUtils.kGap12,
                            Text(
                              'Пока нет отзывов',
                              style: context.textStyle.regularSubheadline,
                            ),
                            Padding(
                              padding: AppUtils.kPaddingAll8,
                              child: Text(
                                'Поделитесь своим опытом, написав первый отзыв',
                                style: context.textStyle.regularSubheadline.copyWith(
                                  color: const Color(0xFF828F89),
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
                scrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
              },
            ),
          ),
        ),
      );
}
