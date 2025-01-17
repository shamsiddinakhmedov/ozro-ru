import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/main/home/products_list_response.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';
import 'package:ozro_mobile/src/injector_container.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/home/home_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/main/main_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/image_network/custom_cached_network_image.dart';

class ProductItemWidget extends StatefulWidget {
  const ProductItemWidget({
    super.key,
    required this.product,
    required this.itemWidth,
    required this.itemHeight,
    required this.textHeight,
    required this.onTap,
    required this.index,
  });

  final ProductsListResponse product;
  final double itemWidth;
  final double itemHeight;
  final double textHeight;
  final int index;
  final VoidCallback onTap;

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  ValueNotifier<bool> isFavorite = ValueNotifier(false);
  ValueNotifier<bool> isLiked = ValueNotifier(false);

  late int likeCount = 0;
  @override
  void initState() {
    isFavorite.value = widget.product.favorite ?? false;
    isLiked.value = widget.product.liked ?? false;
    likeCount = widget.product.likes ?? 0;
    super.initState();
  }

  Future<void> onFavorite() async {
    isFavorite.value = !isFavorite.value;
    final result = await sl<MainRepository>().addToFavorites(productId: widget.product.id);
    result.fold(
      (l) {
        isFavorite.value = !isFavorite.value;
      },
      (r) {
        !(widget.product.favorite ?? false)
            ? context.read<MainBloc>().add(const MainFetchFavoriteProducts())
            : context.read<HomeBloc>().add(
              HomeAddToFavoritesEvent(
                product: widget.product,
                index: widget.index,
              ),
            );
      },
    );
  }

  Future<void> onLike() async {
    isLiked.value = !isLiked.value;
    setState(() {
      likeCount = isLiked.value ? likeCount += 1 : likeCount -= 1;
    });
    final result = await sl<MainRepository>().postLike(productId: widget.product.id);
    result.fold(
      (l) {
        isLiked.value = !isLiked.value;
      },
      (r) {
        context.read<HomeBloc>().add(
              HomeLikeProductEvent(
                product: widget.product,
                index: widget.index,
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: widget.onTap,
        borderRadius: AppUtils.kBorderRadius12,
        child: SizedBox(
          width: widget.itemWidth,
          height: widget.itemHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: AppUtils.kBorderRadius12,
              color: context.color.lightGrey4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: widget.itemHeight - widget.textHeight - 10,
                  width: widget.itemWidth + 10,
                  child: ClipRRect(
                    borderRadius: AppUtils.kBorderRadius12.copyWith(
                      bottomRight: Radius.zero,
                      bottomLeft: Radius.zero,
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      children: [
                        CustomCachedNetworkImage(
                          key: ObjectKey('CustomCachedNetworkImage key object ${widget.product.id}'),
                          imageUrl: widget.product.image?.link ?? '',
                          borderRadius: AppUtils.kBorderRadiusOnlyTop12,
                          fit: BoxFit.cover,
                          imageColor: context.color.lightGrey4,
                        ),
                        Positioned(
                          right: 7,
                          top: 7,
                          child: GestureDetector(
                            onTap: () {
                              if (localSource.hasProfile) {
                                onFavorite();
                              } else {
                                context.pushNamed(
                                  Routes.auth,
                                  extra: true,
                                );
                              }
                            },
                            child: ValueListenableBuilder(
                              key: ObjectKey('ValueListenableBuilder key object ${widget.product.id}'),
                              valueListenable: isFavorite,
                              builder: (_, value, __) => Icon(
                                value ? AppIcons.favoriteFilled : AppIcons.favorite,
                                color: value ? context.colorScheme.error : context.color.midGrey4,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: AppUtils.kPaddingAll6,
                    child: Text(
                      widget.product.title ?? '',
                      maxLines: 2,
                      style: context.textStyle.regularFootnote,
                    ),
                  ),
                ),
                Padding(
                  padding: AppUtils.kPaddingAll4.copyWith(top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (localSource.hasProfile) {
                              onLike();
                          } else {
                            context.pushNamed(
                              Routes.auth,
                              extra: true,
                            );
                          }
                        },
                        icon: ValueListenableBuilder(
                          valueListenable: isLiked,
                          builder: (_, value, __) => Icon(
                            value ? Icons.thumb_up_alt_sharp : AppIcons.like,
                            color: context.color.midGrey4,
                            // size: 16,
                          ),
                        ),
                      ),
                      // AppUtils.kGap4,
                      Text(
                        likeCount.toString(),
                        style: TextStyle(
                          color: context.color.midGrey4,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      AppUtils.kGap6,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
