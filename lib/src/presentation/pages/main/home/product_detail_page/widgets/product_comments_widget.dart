part of '../product_detail_page.dart';

class _ProductCommentsWidget extends StatelessWidget {
  const _ProductCommentsWidget({super.key, required this.product, required this.onReplyPressed});

  final ProductsListResponse? product;
  final VoidCallback onReplyPressed;

  @override
  Widget build(BuildContext context) {
    final comments = context.select<ProductDetailBloc, List<CommentListResponse>>(
      (bloc) => bloc.state.comments,
    );

    final commentsStatus = context.select<ProductDetailBloc, ApiStatus>(
      (bloc) => bloc.state.commentsStatus,
    );

    return DecoratedSliver(
      key: key,
      decoration: BoxDecoration(
        borderRadius: AppUtils.kBorderRadiusOnlyBottom12,
        color: context.color.white,
      ),
      sliver: commentsStatus.isLoading
          ? const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : !commentsStatus.isLoading && comments.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage(Assets.pngCommentaryNotFound),
                        ),
                        AppUtils.kGap12,
                        Text(
                          'Пока комментариев нет',
                          style: context.textStyle.regularSubheadline,
                        ),
                        Padding(
                          padding: AppUtils.kPaddingAll8,
                          child: Text(
                            'Оставьте первый комментарий и начните обсуждение.',
                            style: context.textStyle.regularSubheadline.copyWith(
                              color: const Color(0xFF828F89),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverListSeparatorBuilder(
                  padding: AppUtils.kPaddingAll16,
                  itemCount: comments.length,
                  itemBuilder: (_, index) => _CommentWidget(
                    key: ObjectKey('CommentWidget ${product?.id} $index'),
                    comment: comments[index],
                    onReplyPressed: onReplyPressed,
                  ),
                  separatorBuilder: (_, index) => AppUtils.kDividerWithPaddingVer12,
                ),
    );
  }
}

class _CommentWidget extends StatelessWidget {
  const _CommentWidget({super.key, required this.comment, required this.onReplyPressed});

  final CommentListResponse comment;
  final VoidCallback onReplyPressed;

  @override
  Widget build(BuildContext context) => Row(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCachedNetworkImage(
            borderRadius: AppUtils.kBorderRadius100,
            defaultWord: comment.user ?? '',
            defaultWordStyle: context.textStyle.regularSubheadline.copyWith(
              color: context.colorScheme.onSurface,
            ),
            iconBackColor: context.color.lightGrey4,
            imageColor: context.color.lightGrey4,
            imageUrl: '',
            height: 40,
            width: 40,
          ),
          AppUtils.kGap6,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppUtils.kBorderRadius12.copyWith(topLeft: Radius.zero),
                    color: (comment.isOwn ?? false)
                        ? context.colorScheme.primary.withOpacity(0.1)
                        : context.color.lightGrey4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: AppUtils.kPaddingAll8,
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment.user ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textStyle.regularSubheadline.copyWith(
                                color: context.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // AppUtils.kGap32,
                            Text(
                              comment.sourceDate ?? '',
                              style: context.textStyle.regularCaption2.copyWith(color: const Color(0xff6E7C87)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: AppUtils.kPaddingHorizontal8,
                        child: Row(
                          children: [
                            // Text(
                            //   comment.user ?? '',
                            //   style: context.textStyle.regularSubheadline.copyWith(
                            //     color: context.colorScheme.primary,
                            //   ),
                            // ),
                            // if (comment.user != null) AppUtils.kGap6,
                            Expanded(
                              child: Text(
                                comment.content ?? '',
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyle.regularSubheadline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (comment.files?.isNotEmpty ?? false) ...[
                        AppUtils.kGap8,
                        CustomCachedNetworkImage(
                          imageColor:  context.color.lightGrey4,
                          borderRadius: AppUtils.kBorderRadius0,
                          defaultWord: comment.user ?? '',
                          defaultWordStyle: context.textStyle.regularSubheadline.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                          alignment: Alignment.centerLeft,
                          iconBackColor: context.color.lightGrey4,
                          imageUrl: comment.files?.firstOrNull?.link ?? '',
                          height: context.kSize.height / 3.5,
                          width: context.kSize.width * 0.5,
                          fit: BoxFit.contain,
                        ),
                      ],
                      AppUtils.kGap8,
                      Padding(
                        padding: AppUtils.kPaddingHorizontal8,
                        child: InkWell(
                          onTap: () {
                            if (localSource.hasProfile) {
                              onReplyPressed();
                              context.read<ProductDetailBloc>().add(
                                    ProductDetailReplyPressedEvent(
                                      comment: comment,
                                    ),
                                  );
                            } else {
                              context.pushNamed(Routes.auth, extra: true);
                            }
                          },
                          child: Text(
                            'Ответить',
                            style: context.textStyle.regularSubheadline.copyWith(
                              color: context.colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (comment.repliedComments?.isNotEmpty ?? false) ...[
                  for (final comment in comment.repliedComments ?? []) ...[
                    AppUtils.kGap12,
                    _CommentWidget(
                      comment: comment,
                      onReplyPressed: onReplyPressed,
                    ),
                  ]
                ]
              ],
            ),
          ),
        ],
      );
}
