import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/home/product_detail/comment_list_response.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/profile/my_comments/my_comments_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/custom_popup_menu_widget/custom_popup_menu_widget.dart';
import 'package:ozro_mobile/src/presentation/components/image_network/custom_cached_network_image.dart';
import 'package:ozro_mobile/src/presentation/components/sliver/sliver_list_separator_builder.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/my_comments_page/widgets/my_comment_shimmer_widget.dart';
import 'package:ozro_mobile/src/presentation/pages/main/profile/my_feedbacks_page/edit_my_comment/edit_my_comment_page.dart';

part 'widgets/my_comment_item_widget.dart';

class MyCommentsPage extends StatefulWidget {
  const MyCommentsPage({super.key});

  @override
  State<MyCommentsPage> createState() => _MyCommentsPageState();
}

class _MyCommentsPageState extends State<MyCommentsPage> {
  late final ScrollController scrollController;
  final ValueNotifier<bool> isEndList = ValueNotifier<bool>(false);

  @override
  void initState() {
    scrollController = ScrollController()..addListener(_onScroll);
    context.read<MyCommentsBloc>().add(const MyCommentsFetchEvent());
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.offset > 50) {
      isEndList.value = true;
    } else if (isEndList.value) {
      isEndList.value = false;
    }
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll == currentScroll && context.read<MyCommentsBloc>().state.paginationStatus.isNotDone) {
      debugLog('onScroll: getComments');
      context.read<MyCommentsBloc>().add(
            const MyCommentsFetchEvent(
              isRefresh: false,
            ),
          );
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (mounted) {
          context.read<MyCommentsBloc>().add(const MyCommentsFetchEvent());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Мои комментарии'),
          shape: const RoundedRectangleBorder(borderRadius: AppUtils.kBorderRadiusOnlyBottom16),
        ),
        body: BlocBuilder<MyCommentsBloc, MyCommentsState>(
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
                if(state.myCommentsStatus.isLoading)
                  SliverListSeparatorBuilder(
                    padding: AppUtils.kPaddingAll12,
                    itemCount: 20,
                    itemBuilder: (_, index) => const MyCommentShimmerWidget(),
                    separatorBuilder: (_, index) => AppUtils.kGap12,
                  ),
                if (state.comments.isNotEmpty) ...[
                  SliverListSeparatorBuilder(
                    padding: AppUtils.kPaddingAll12,
                    itemCount: state.comments.length,
                    itemBuilder: (_, index) => _MyCommentItemWidget(
                      key: ObjectKey('_MyCommentItemWidget comment_${state.comments[index].id}'),
                      comment: state.comments[index],
                      index: index,
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
                if (!state.myCommentsStatus.isLoading && state.comments.isEmpty)
                  SliverFillRemaining(
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
                            'Пока нет комментариев',
                            style: context.textStyle.regularSubheadline,
                          ),
                          Padding(
                            padding: AppUtils.kPaddingAll8,
                            child: Text(
                              'Начните обсуждение, оставив первый комментарий',
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
                  )
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
