part of '../my_comments_page.dart';

class _MyCommentItemWidget extends StatelessWidget {
  const _MyCommentItemWidget({super.key, required this.comment, required this.index});

  final CommentListResponse comment;
  final int index;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        key: key,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: AppUtils.kBorderRadius12,
        ),
        child: Padding(
          padding: AppUtils.kPaddingAll12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: AppUtils.kBorderRadius8,
                    child: SizedBox(
                      width: context.kSize.width * 0.08,
                      height: context.kSize.width * 0.08,
                      child: CustomCachedNetworkImage(
                        key: ObjectKey('CustomCachedNetworkImage key _MyCommentItemWidget ${comment.id}'),
                        imageUrl: comment.productImage?.link ?? '',
                        imageColor: context.colorScheme.surface,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AppUtils.kGap12,
                  Expanded(
                    child: Text(
                      comment.productName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyle.regularSubheadline.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  // AppUtils.kSpacer,
                  CustomPopUpMenuWidget(
                    onEdit: () {
                      context
                          .pushNamed<bool>(
                        Routes.editMyComment,
                        extra: EditMyCommentArgs(
                          comment: comment,
                          fromComment: true,
                        ),
                      )
                          .then(
                        (value) {
                          if (value is bool && value && context.mounted) {
                            context.read<MyCommentsBloc>().add(
                                  const MyCommentsFetchEvent(),
                                );
                          }
                        },
                      );
                    },
                    onDelete: () {
                      context.read<MyCommentsBloc>().add(
                            MyCommentsDeleteEvent(
                              comment: comment,
                              index: index,
                            ),
                          );
                    },
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              AppUtils.kGap12,
              Text(
                comment.content ?? '',
                style: context.textStyle.regularCallout,
              ),
            ],
          ),
        ),
      );
}
