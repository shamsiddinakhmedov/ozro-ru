import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/generated/assets.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/favorites/favorite_products_list_response.dart';
import 'package:ozro_mobile/src/data/models/main/home/products_list_response.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/main/main_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/product_detail_page/product_detail_page.dart';

import 'widgets/favorite_product_item_widget.dart';

class MyFavoritesPage extends StatefulWidget {
  const MyFavoritesPage({super.key});

  @override
  State<MyFavoritesPage> createState() => _MyFavoritesPageState();
}

class _MyFavoritesPageState extends State<MyFavoritesPage> {
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll == currentScroll && context.read<MainBloc>().state.favoritePaginationStatus.isNotDone) {
      context.read<MainBloc>().add(
            const MainFetchFavoriteProducts(isRefresh: false),
          );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = (context.kSize.width - 48) / 2;
    var crossAxisCount = 2;

    final iPadOrTablet = !(context.kSize.width < 600 && (Platform.isAndroid || Platform.isIOS));
    if (iPadOrTablet) {
      itemWidth = (context.kSize.width - 100) / 4;
      crossAxisCount = 4;
    }
    const double textHeight = 80;
    final double itemHeight = itemWidth * 1.43 + textHeight;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Избранные'),
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (_, state) => RefreshIndicator.adaptive(
          onRefresh: () async {
            await Future.delayed(
              const Duration(milliseconds: 300),
              () {
                if (context.mounted) {
                  context.read<MainBloc>().add(const MainFetchFavoriteProducts());
                }
              },
            );
          },
          child: ModalProgressHUD(
            inAsyncCall: state.favoriteProductsStatus.isLoading,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (state.favoriteProducts.isNotEmpty) ...[
                  SliverPadding(
                    padding: AppUtils.kPaddingHorizontal8,
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: itemWidth / itemHeight,
                        // mainAxisExtent: 10,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: state.favoriteProducts.length,
                      itemBuilder: (_, index) => FavoriteProductItemWidget(
                        key: ObjectKey('FavoriteProductItemWidget ${state.favoriteProducts[index].id}'),
                        product: state.favoriteProducts[index].product ?? ProductsListResponse(),
                        itemWidth: itemWidth,
                        itemHeight: itemHeight,
                        textHeight: textHeight,
                        onTap: () {
                          if (state.favoriteProducts[index].product == null) return;
                          context.pushNamed(
                            Routes.productDetail,
                            extra: ProductDetailPageArgs(
                              product: state.favoriteProducts[index].product,
                              productId: state.favoriteProducts[index].product?.id,
                            ),
                          );
                        },
                        index: index,
                      ),
                    ),
                  ),
                  SliverAnimatedOpacity(
                    opacity: state.favoritePaginationStatus.isLoading ? 1 : 0,
                    duration: animationDuration,
                    sliver: const SliverToBoxAdapter(
                      child: SafeArea(
                        minimum: AppUtils.kPaddingHorizontal16,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppUtils.kGap8,
                            CircularProgressIndicator.adaptive(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                if (state.favoriteProducts.isEmpty && !state.favoriteProductsStatus.isLoading)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(image: AssetImage(Assets.pngFavoritesNotFound)),
                          AppUtils.kGap12,
                          Text(
                            'Избранного нет',
                            style: context.textStyle.regularSubheadline,
                          ),
                          Padding(
                            padding: AppUtils.kPaddingAll8,
                            child: Text(
                              'Начните сохранять интересные товары',
                              style: context.textStyle.regularSubheadline.copyWith(
                                color: const Color(0xFF828F89),
                                fontSize: 13,
                              ),
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
      ),
    );
  }
}
