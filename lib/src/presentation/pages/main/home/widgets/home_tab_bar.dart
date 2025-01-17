import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/data/models/main/home/categories_list_response.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({
    super.key,
    required this.onTabChanged,
    required this.tabController,
    required this.categories,
    required this.selectedTab,
  });

  final ValueNotifier<int> selectedTab;
  final List<CategoriesListResponse> categories;
  final ValueChanged<int> onTabChanged;
  final TabController tabController;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
        valueListenable: selectedTab,
        builder: (_, index, __) => SliverAppBar(
          pinned: true,
          expandedHeight: 0,
          floating: true,
          toolbarHeight: 0,
          titleSpacing: 0,
          // backgroundColor: context.color.background,
          backgroundColor: context.colorScheme.surface,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelColor: context.colorScheme.onPrimary,
                      unselectedLabelColor: context.color.black,
                      indicator: BoxDecoration(
                        color: context.color.background,
                        borderRadius: AppUtils.kBorderRadius12,
                      ),
                      splashBorderRadius: BorderRadius.circular(12),
                      controller: tabController,
                      padding: AppUtils.kPaddingHorizontal8.copyWith(left: 0),
                      labelPadding: AppUtils.kPaddingHorizontal6,
                      indicatorPadding: AppUtils.kPaddingHorizontal6,
                      indicatorWeight: 0,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.primary,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: context.color.black,
                      ),
                      tabs: List<Widget>.generate(
                        categories.length,
                        (i) => DecoratedBox(
                          decoration: BoxDecoration(
                            color: index == i ? context.colorScheme.primary : context.color.lightGrey4,
                            borderRadius: AppUtils.kBorderRadius12,
                          ),
                          child: Padding(
                            padding: AppUtils.kPaddingHorizontal16,
                            child: Tab(
                              height: 40,
                              child: Text(categories[i].title ?? ''),
                            ),
                          ),
                        ),
                      ),
                      onTap: onTabChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
