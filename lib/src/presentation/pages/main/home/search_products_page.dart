import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozro_mobile/src/config/router/app_routes.dart';
import 'package:ozro_mobile/src/core/constants/constants.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/enum_status.dart';
import 'package:ozro_mobile/src/presentation/bloc/main/home/home_bloc.dart';
import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
import 'package:ozro_mobile/src/presentation/components/loading_widgets/modal_progress_hud.dart';
import 'package:ozro_mobile/src/presentation/components/search_widget/debouncer.dart';
import 'package:ozro_mobile/src/presentation/pages/main/home/product_detail_page/product_detail_page.dart';

import 'widgets/product_item_widget.dart';

class SearchProductsPage extends StatefulWidget {
  const SearchProductsPage({super.key});

  @override
  State<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  late final ScrollController scrollController;
  final Debouncer deBouncer = Debouncer(milliseconds: 300);
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll == currentScroll && context.read<HomeBloc>().state.paginationStatus.isNotDone) {
      context.read<HomeBloc>().add(
            HomeFetchProductsEvent(
              isRefresh: false,
              search: searchController.text.trim(),
            ),
          );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
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
    final double itemHeight = itemWidth * 1.5 + textHeight;

    return Scaffold(
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
            child: CustomTextField(
              hintText: 'Поиск',
              filled: true,
              autofocus: true,
              controller: searchController,
              prefixIcon: GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: context.color.black,
                ),
              ),
              onChanged: (p0) {
                deBouncer.run(() {
                  context.read<HomeBloc>().add(
                        HomeFetchProductsEvent(
                          search: p0 ?? '',
                        ),
                      );
                });
              },
              fillColor: context.color.disabled,
              suffixIcon: GestureDetector(
                onTap: () {
                  searchController.clear();
                  context.read<HomeBloc>().add(
                        const HomeFetchProductsEvent(forSearch: true),
                      );
                },
                child: Icon(
                  Icons.close,
                  size: 24,
                  color: context.color.midGrey4,
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (_, state) => ModalProgressHUD(
          inAsyncCall: state.productsStatus.isLoading,
          child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
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
                  itemBuilder: (_, index) => ProductItemWidget(
                    key: ObjectKey('ProductItemWidget product_${state.products[index].id}'),
                    product: state.products[index],
                    itemWidth: itemWidth,
                    itemHeight: itemHeight,
                    textHeight: textHeight,
                    index: index,
                    onTap: () {
                      context.pushNamed(
                        Routes.productDetail,
                        extra: ProductDetailPageArgs(
                          product: state.products[index],
                          productId: state.products[index].id,
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (state.products.isNotEmpty)
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
                            child: CircularProgressIndicator.adaptive(),
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
    );
  }
}
