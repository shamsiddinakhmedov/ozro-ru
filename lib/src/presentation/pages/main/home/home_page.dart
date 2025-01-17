import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/data/models/main/favorites/favorite_products_list_response.dart';
import 'package:ozro_mobile/src/domain/repositories/main/main_repository.dart';
import 'package:ozro_mobile/src/injector_container.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/home/home_bloc.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/main/main_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/product_detail_page/product_detail_page.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/widgets/banner_ads_widget.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/widgets/product_item_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widget_lifecycle/widget_lifecycle.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import 'widgets/home_tab_bar.dart';

part 'mixin/home_mixin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeMixin, TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    double itemWidth = (context.kSize.width - 48) / 2;
    var crossAxisCount = 2;

    final iPadOrTablet = context.kSize.width > 600 && (Platform.isAndroid || Platform.isIOS);
    if (iPadOrTablet) {
      itemWidth = (context.kSize.width - 100) / 4;
      crossAxisCount = 4;
    }
    const double textHeight = 80;
    final double itemHeight = itemWidth * 1.5 + textHeight;

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) => previous.categories != current.categories,
          listener: (_, state) {
            debugLog('state categories length ${state.categories.length}');
            if (state.categories.isNotEmpty) {
              debugLog('state.categories.isNotEmpty');
              tabController = TabController(
                length: state.categories.length,
                vsync: this,
              );
            }
          },
        ),
        BlocListener<MainBloc, MainState>(
          listenWhen: (previous, current) => previous.scrollToTopHome != current.scrollToTopHome,
          listener: (context, state) {
            if (state.scrollToTopHome && (scrollController.position.pixels != 0 || selectedTab.value != 0)) {
              tabController.animateTo(0);
              selectedTab.value = 0;
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              context.read<HomeBloc>().add(const HomeFetchProductsEvent());
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size(
              double.infinity,
              kToolbarHeight - 32,
            ),
            child: Padding(
              padding: AppUtils.kPaddingAll16,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // context
                        //     .pushNamed<bool>(
                        //   Routes.productDetail,
                        //   extra: const ProductDetailPageArgs(
                        //     productId: 490,
                        //     feedbackId: 9553,
                        //     withProductId: true,
                        //
                        //   ),
                        // );
                        context.pushNamed(Routes.searchProducts).then(
                          (value) {
                            if (context.mounted) {
                              context.read<HomeBloc>().add(const HomeFetchCategoriesEvent());
                              selectedTab.value = 0;
                              tabController.animateTo(0);
                            }
                          },
                        );
                      },
                      child: CustomTextField(
                        hintText: 'Поиск',
                        filled: true,
                        readOnly: true,
                        enabled: false,
                        onTap: () => context.pushNamed(Routes.searchProducts),
                        prefixIcon: Icon(
                          Icons.search_outlined,
                          size: 20,
                          color: context.color.midGrey4,
                        ),
                        fillColor: context.color.disabled,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 48,
                    margin: const EdgeInsets.only(left: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xffF5F5F5),
                      borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        BlocBuilder<MainBloc, MainState>(
                          buildWhen: (previous, current) => previous.hasUnreadNotifications != current.hasUnreadNotifications,
                          builder: (_, state) => Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: state.hasUnreadNotifications ? Colors.red : Colors.transparent,
                                  borderRadius: const BorderRadius.all(Radius.circular(12))
                              )
                          )
                        ),
                        IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () async {
                            if (localSource.hasProfile) {
                              await context.pushNamed(Routes.notification);
                            } else {
                              await context.pushNamed(Routes.auth, extra: true);
                            }
                          },
                          icon: Icon(
                            Icons.notifications_none_outlined,
                            size: 24,
                            color:context.color.midGrey4,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: LifecycleAware(
          observer: LifecycleObserver(
              onVisible: (a) async {
                if (localSource.accessToken.isNotEmpty) {
                  await sl<MainRepository>().getUserInfo();
                }
              }
          ),
          builder: (BuildContext context, Lifecycle lifecycle) =>BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (p, c) => p.categories != c.categories || p.products != c.products,
            builder: (_, state) => RefreshIndicator.adaptive(
              onRefresh: () async {

                await Future.delayed(
                  const Duration(milliseconds: 300),
                  () {
                    if (context.mounted) {
                      context.read<HomeBloc>().add(HomeFetchProductsEvent(categoryId: state.categories.isNotEmpty ? state.categories[selectedTab.value].id : null),);
                    }
                  },
                );
              },
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx > 0) {
                    // Swipe Right
                    print('Swiped Right!');
                    if (selectedTab.value > 0) {
                      selectedTab.value -= 1;
                      context.read<HomeBloc>().add(
                        HomeFetchProductsEvent(categoryId: state.categories[selectedTab.value].id),
                      );
                      tabController.animateTo(selectedTab.value);
                      scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  } else if (details.velocity.pixelsPerSecond.dx < 0) {
                    // Swipe Left
                    if ((selectedTab.value + 1) < (state.categories.length)) {
                      selectedTab.value += 1;
                      context.read<HomeBloc>().add(
                        HomeFetchProductsEvent(categoryId: state.categories[selectedTab.value].id),
                      );
                      tabController.animateTo(selectedTab.value);
                      scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  }
                },
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    if (state.categories.isNotEmpty)
                      HomeTabBar(
                        onTabChanged: (index) {
                          if (selectedTab.value != index) {
                            context.read<HomeBloc>().add(HomeFetchProductsEvent(categoryId: state.categories[index].id));
                          }
                          selectedTab.value = index;
                          tabController.animateTo(index);
                          scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                        selectedTab: selectedTab,
                        tabController: tabController,
                        categories: state.categories,
                      ),
                    if (state.categoriesStatus.isLoading)
                      SliverPadding(
                        padding: AppUtils.kPaddingVertical4,
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            height: 50,
                            child: ListView.separated(
                              padding: AppUtils.kPaddingAll4,
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (_, index) => _categoryShimmerWidget(),
                              separatorBuilder: (_, index) => const SizedBox(width: 12),
                            ),
                          ),
                        ),
                      ),
                    // if (isBannerAlreadyCreated)
                    if (state.isLoading)
                      SliverPadding(
                        padding: AppUtils.kPaddingHorizontal8,
                        sliver: SliverGrid.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: itemWidth / itemHeight,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemCount: 10,
                          itemBuilder: (_, index) => _productShimmerWidget(
                              itemWidth: itemWidth, itemHeight: itemHeight, context: context, textHeight: textHeight),
                        ),
                      ),
                    if (state.products.isNotEmpty && !state.isLoading)
                      SliverPadding(
                        padding: AppUtils.kPaddingHorizontal8,
                        sliver: SliverGrid.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: itemWidth / itemHeight,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemCount: state.products.length,
                          itemBuilder: (_, index) => (index == 9
                              // || index == 20 || index == 30
                              )
                              ? BannerAdsWidget(
                                  index: index,
                                  key: ObjectKey('BannerAdsWidget $index'),
                                  isLoading: isLoading11,
                                  // index == 10
                                  //     ?
                                  // isLoading11
                                  // : index == 20
                                  //     ? isLoading21
                                  //     : isLoading31,
                                  isDismissed: ValueNotifier(false),
                                  banner: banner11,
                                  // index == 10
                                  //           ? banner11
                                  //           : index == 20
                                  //               ? banner21
                                  //               : banner31,
                                  child: ProductItemWidget(
                                    key: ObjectKey('ProductItemWidget product_${state.products[index].id}'),
                                    product: state.products[index],
                                    itemWidth: itemWidth,
                                    itemHeight: itemHeight,
                                    textHeight: textHeight,
                                    index: index,
                                    onTap: () {
                                      context.pushNamed<bool>(
                                        Routes.productDetail,
                                        extra: ProductDetailPageArgs(
                                          product: state.products[index],
                                          productId: state.products[index].id,
                                        ),
                                      ).then(
                                        (value) {
                                          if (value is bool && value && context.mounted) {
                                            context.read<HomeBloc>().add(
                                                  HomeAddToFavoritesEvent(
                                                    product: state.products[index],
                                                    index: index,
                                                  ),
                                                );
                                            context.read<MainBloc>().add(const MainFetchFavoriteProducts());
                                          }
                                        },
                                      );
                                    },
                                  ),
                                )
                              : ProductItemWidget(
                                  key: ObjectKey('ProductItemWidget product_${state.products[index].id}'),
                                  product: state.products[index],
                                  itemWidth: itemWidth,
                                  itemHeight: itemHeight,
                                  textHeight: textHeight,
                                  index: index,
                                  onTap: () {
                                    context.pushNamed<bool>(
                                      Routes.productDetail,
                                      extra: ProductDetailPageArgs(
                                        product: state.products[index],
                                        productId: state.products[index].id,
                                      ),
                                    ).then(
                                      (value) {
                                        if (value is bool && value && context.mounted) {
                                          context.read<HomeBloc>().add(
                                            HomeAddToFavoritesEvent(
                                              product: state.products[index],
                                              index: index,
                                            ),
                                          );
                                          context.read<MainBloc>().add(const MainFetchFavoriteProducts());
                                        }
                                      },
                                    );
                                  },
                                ),
                        ),
                      ),
                    if (state.products.isNotEmpty)
                      SliverAnimatedOpacity(
                        opacity: state.paginationStatus.isPagination ? 1 : 0,
                        duration: animationDuration,
                        sliver: SliverToBoxAdapter(
                          child: SafeArea(
                            minimum: AppUtils.kPaddingHorizontal16,
                            child: Column(
                              children: [
                                AppUtils.kGap8,
                                Center(
                                  child: CircularProgressIndicator.adaptive(strokeWidth: 1, backgroundColor: context.color.midGrey4.withOpacity(0.3)),
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
      ),
    );
  }
}
