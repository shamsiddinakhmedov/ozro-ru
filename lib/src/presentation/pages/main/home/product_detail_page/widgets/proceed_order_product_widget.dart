part of '../product_detail_page.dart';

class _ProceedOrderProductWidget extends StatelessWidget {
  const _ProceedOrderProductWidget({super.key, required this.product});

  final ProductsListResponse? product;

  @override
  Widget build(BuildContext context) => DecoratedSliver(
        key: key,
        decoration: BoxDecoration(
          borderRadius: AppUtils.kBorderRadius12,
          color: context.color.white,
        ),
        sliver: SliverToBoxAdapter(
          child: Padding(
            padding: AppUtils.kPaddingAll16,
            child: Material(
              color: context.color.lightGrey4,
              shape: AppUtils.kShapeRoundedAll12,
              child: ListTile(
                onTap: () {
                  if(product?.link == null) return;
                  launchUrl(Uri.parse(product?.link??''));
                },
                shape: AppUtils.kShapeRoundedAll12,
                contentPadding: AppUtils.kPaddingZero.copyWith(left: 6),
                // tileColor: ,
                // focusColor: context.color.background,
                leading: const Image(
                  image: AssetImage(Assets.pngClipboard),
                  fit: BoxFit.cover,
                ),
                title: Text(
                  product?.title??'',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.regularSubheadline.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Перейдите для заказа товара',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.regularFootnote.copyWith(color: context.color.darkGrey3),
                ),
                trailing: IconButton(
                  onPressed: () {
                    if(product?.link == null) return;
                    launchUrl(Uri.parse(product?.link??''));
                  },
                  highlightColor: context.colorScheme.primary.withOpacity(0.05),
                  splashColor: context.colorScheme.primary.withOpacity(0.1),
                  icon: const Icon(
                    Icons.launch_sharp,
                    color: Color(0xFF84919A),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
