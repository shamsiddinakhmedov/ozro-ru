import 'package:flutter/cupertino.dart';

class SliverListSeparatorBuilder extends StatelessWidget {
  const SliverListSeparatorBuilder({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.itemCount,
    this.padding,
  });

  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index) separatorBuilder;
  final int? itemCount;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => SliverSafeArea(
        minimum: padding ?? EdgeInsets.zero,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index.isEven) {
                return itemBuilder(context, index ~/ 2);
              }
              return separatorBuilder(context, index ~/ 2);
            },
            childCount: (itemCount ?? 0) * 2 - 1,
          ),
        ),
      );
}
