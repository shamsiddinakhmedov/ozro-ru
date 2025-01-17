part of '../my_feedbacks_page.dart';

class _MyFeedbackItemWidget extends StatelessWidget {
  const _MyFeedbackItemWidget(
      {super.key,
      required this.feedback,
      required this.onDelete,
      required this.onEdit,
      required this.onShowThisFeedback});

  final CommentListResponse feedback;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShowThisFeedback;

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
                        imageColor: context.colorScheme.surface,
                        key: ObjectKey('CustomCachedNetworkImage key _MyCommentItemWidget ${feedback.id}'),
                        imageUrl: feedback.productImage?.link ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AppUtils.kGap12,
                  Expanded(
                    child: Text(
                      feedback.productName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyle.regularSubheadline.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  // AppUtils.kSpacer,
                  CustomPopUpMenuWidget(
                    onEdit: onEdit,
                    onDelete: onDelete,
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              AppUtils.kGap12,
              Text(
                feedback.content ?? '',
                style: context.textStyle.regularCallout,
              ),
              AppUtils.kGap12,
              ElevatedButton(
                style: ButtonStyle(
                  // minimumSize: WidgetStatePropertyAll(Size.fromWidth(context.kSize.width-50)),
                  // maximumSize: WidgetStatePropertyAll(Size.fromWidth(context.kSize.width-48)),
                  fixedSize: WidgetStatePropertyAll(Size.fromWidth(context.kSize.width)),
                  backgroundColor: WidgetStatePropertyAll<Color>(context.color.disabled),
                  foregroundColor: WidgetStatePropertyAll<Color>(context.color.black),
                  textStyle: WidgetStatePropertyAll(
                    context.textStyle.regularSubheadline.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                onPressed: onShowThisFeedback,
                child: const Text('Перейти на этот отзыв'),
              ),
            ],
          ),
        ),
      );
}
