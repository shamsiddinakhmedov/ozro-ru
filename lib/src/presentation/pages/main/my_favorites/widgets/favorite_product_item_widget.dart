import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/main/favorites/favorite_products_list_response.dart';
import 'package:ozro_mobile/src/data/models/main/home/products_list_response.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';
import 'package:ozro_mobile/src/injector_container.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/main/main_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/image_network/custom_cached_network_image.dart';

class FavoriteProductItemWidget extends StatefulWidget {
  const FavoriteProductItemWidget({
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
  State<FavoriteProductItemWidget> createState() => _FavoriteProductItemWidgetState();
}

class _FavoriteProductItemWidgetState extends State<FavoriteProductItemWidget> {
  ValueNotifier<bool> isFavorite = ValueNotifier(false);
  ValueNotifier<bool> isLiked = ValueNotifier(false);

  @override
  void initState() {
    isFavorite.value = widget.product.favorite ?? false;
    isLiked.value = widget.product.liked ?? false;
    super.initState();
  }

  Future<void> onFavorite() async {
    isFavorite.value = false;
    final result = await sl<MainRepository>().addToFavorites(productId: widget.product.id);
    result.fold(
      (l) {
        isFavorite.value = true;
      },
      (r) {
        context.read<MainBloc>().add(const MainFetchFavoriteProducts(updateStatus: false));
      },
    );
  }

  Future<void> onLike() async {
    isLiked.value = !isLiked.value;
    final result = await sl<MainRepository>().postLike(productId: widget.product.id);
    result.fold(
      (l) {
        isLiked.value = !isLiked.value;
      },
      (r) {
        context.read<MainBloc>().add(
              const MainFetchFavoriteProducts(updateStatus: false),
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
                        SizedBox.expand(
                          child: CustomCachedNetworkImage(
                            key: ObjectKey('CustomCachedNetworkImage key object ${widget.product.id}'),
                            imageUrl: widget.product.image?.link ?? '',
                            fit: BoxFit.cover,
                          ),
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
                      // AppUtils.kGap6,
                      Text(
                        widget.product.likes.toString(),
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
