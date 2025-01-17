// // ignore_for_file: discarded_futures, avoid_annotating_with_dynamic
//
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:rect_getter/rect_getter.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
//
// sealed class VerticalScrollableTabBarStatus {
//   static bool isOnTap = false;
//   static int isOnTapIndex = 0;
//
//   static void setIndex(int index) {
//     VerticalScrollableTabBarStatus.isOnTap = true;
//     VerticalScrollableTabBarStatus.isOnTapIndex = index;
//   }
// }
//
// enum VerticalScrollPosition { begin, middle, end }
//
// class VerticalScrollableTabView<T> extends StatefulWidget {
//   const VerticalScrollableTabView({
//     super.key,
//
//     /// Custom parameters
//     required AutoScrollController autoScrollController,
//     required TabController tabController,
//     required List<T> listItemData,
//     required Widget Function(T aaa, int index) eachItemChild,
//     VerticalScrollPosition verticalScrollPosition = VerticalScrollPosition.begin,
//
//     /// Copy Scrollbar
//     bool? scrollbarThumbVisibility,
//     bool? scrollbarTrackVisibility,
//     double? scrollbarThickness,
//     Radius? scrollbarRadius,
//     bool Function(ScrollNotification)? scrollbarNotificationPredicate,
//     bool? scrollInteractive,
//     ScrollbarOrientation? scrollbarOrientation,
//
//     /// Copy CustomScrollView parameters
//     Axis scrollDirection = Axis.vertical,
//     bool reverse = false,
//     bool? primary,
//     ScrollPhysics? physics,
//     ScrollBehavior? scrollBehavior,
//     bool shrinkWrap = false,
//     Key? center,
//     double anchor = 0.0,
//     double? cacheExtent,
//     required List<Widget> slivers,
//     int? semanticChildCount,
//     DragStartBehavior dragStartBehavior = DragStartBehavior.start,
//     ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
//     String? restorationId,
//     Clip clipBehavior = Clip.hardEdge,
//   })  : _tabController = tabController,
//         _listItemData = listItemData,
//         _eachItemChild = eachItemChild,
//         _verticalScrollPosition = verticalScrollPosition,
//         _autoScrollController = autoScrollController,
//
//         /// Scrollbar
//         _thumbVisibility = scrollbarThumbVisibility,
//         _trackVisibility = scrollbarTrackVisibility,
//         _thickness = scrollbarThickness,
//         _radius = scrollbarRadius,
//         _notificationPredicate = scrollbarNotificationPredicate,
//         _interactive = scrollInteractive,
//         _scrollbarOrientation = scrollbarOrientation,
//
//         /// CustomScrollView
//         _scrollDirection = scrollDirection,
//         _reverse = reverse,
//         _primary = primary,
//         _physics = physics,
//         _scrollBehavior = scrollBehavior,
//         _shrinkWrap = shrinkWrap,
//         _center = center,
//         _anchor = anchor,
//         _cacheExtent = cacheExtent,
//         _slivers = slivers,
//         _semanticChildCount = semanticChildCount,
//         _dragStartBehavior = dragStartBehavior,
//         _keyboardDismissBehavior = keyboardDismissBehavior,
//         _restorationId = restorationId,
//         _clipBehavior = clipBehavior;
//
//   /// TabBar Controller to let widget listening TabBar changed
//   /// TabBar Controller 用來讓 widget 監聽 TabBar 的 index 是否有更動
//   final TabController _tabController;
//
//   /// Required a List<T> Type，you can put your data that you wanna put in item
//   /// 要求 List<T> 的結構，List 裡面可以放自己建立的 Object
//   final List<T> _listItemData;
//
//   /// A callback that return an Object inside _listItemData and the index of ListView.Builder
//   /// A callback 用來回傳一個 _listItemData 裡面的 Object 型態和 ListView.Builder 的 index
//   final Widget Function(T aaa, int index) _eachItemChild;
//
//   /// VerticalScrollPosition = is ann Animation style from scroll_to_index,
//   /// It's show the item position in listView.builder
//   final VerticalScrollPosition _verticalScrollPosition;
//
//   /// Required SliverAppBar, And TabBar must inside of SliverAppBar, and In the TabBar
//   /// onTap: (index) => VerticalScrollableTabBarStatus.setIndex(index);
//   final List<Widget> _slivers;
//
//   final AutoScrollController _autoScrollController;
//
//   /// Copy Scrollbar
//   final bool? _thumbVisibility;
//   final bool? _trackVisibility;
//   final double? _thickness;
//   final Radius? _radius;
//   final bool Function(ScrollNotification)? _notificationPredicate;
//   final bool? _interactive;
//   final ScrollbarOrientation? _scrollbarOrientation;
//
//   /// Copy CustomScrollView parameters
//   final Axis _scrollDirection;
//   final bool _reverse;
//   final bool? _primary;
//   final ScrollPhysics? _physics;
//   final ScrollBehavior? _scrollBehavior;
//   final bool _shrinkWrap;
//   final Key? _center;
//   final double _anchor;
//   final double? _cacheExtent;
//   final int? _semanticChildCount;
//   final DragStartBehavior _dragStartBehavior;
//   final ScrollViewKeyboardDismissBehavior _keyboardDismissBehavior;
//   final String? _restorationId;
//   final Clip _clipBehavior;
//
//   @override
//   State<VerticalScrollableTabView<T>> createState() => _VerticalScrollableTabViewState<T>();
// }
//
// class _VerticalScrollableTabViewState<T> extends State<VerticalScrollableTabView<T>>
//     with SingleTickerProviderStateMixin {
//   /// Instantiate RectGetter（套件提供的方法）
//   final GlobalKey<RectGetterState> listViewKey = RectGetter.createGlobalKey();
//
//   /// To save the item's Rect
//   /// 用來儲存 items 的 Rect 的 Map
//   Map<int, GlobalKey<RectGetterState>> itemsKeys = <int, GlobalKey<RectGetterState>>{};
//
//   @override
//   void initState() {
//     widget._tabController.addListener(_handleTabControllerTick);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     widget._tabController.removeListener(_handleTabControllerTick);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) => RectGetter(
//         key: listViewKey,
//         child: NotificationListener<UserScrollNotification>(
//           onNotification: onScrollNotification,
//           child: Scrollbar(
//             controller: widget._autoScrollController,
//             thumbVisibility: widget._thumbVisibility,
//             trackVisibility: widget._trackVisibility,
//             thickness: widget._thickness,
//             radius: widget._radius,
//             notificationPredicate: widget._notificationPredicate,
//             interactive: widget._interactive,
//             scrollbarOrientation: widget._scrollbarOrientation,
//             child: CustomScrollView(
//               scrollDirection: widget._scrollDirection,
//               reverse: widget._reverse,
//               controller: widget._autoScrollController,
//               primary: widget._primary,
//               physics: widget._physics,
//               scrollBehavior: widget._scrollBehavior,
//               shrinkWrap: widget._shrinkWrap,
//               center: widget._center,
//               anchor: widget._anchor,
//               cacheExtent: widget._cacheExtent,
//               slivers: <Widget>[
//                 ...widget._slivers,
//                 SliverMainAxisGroup(
//                   slivers: List<Widget>.generate(
//                     widget._listItemData.length,
//                     (index) {
//                       itemsKeys[index] = RectGetter.createGlobalKey();
//                       return buildItem(index);
//                     },
//                   ),
//                 ),
//               ],
//               semanticChildCount: widget._semanticChildCount,
//               dragStartBehavior: widget._dragStartBehavior,
//               keyboardDismissBehavior: widget._keyboardDismissBehavior,
//               restorationId: widget._restorationId,
//               clipBehavior: widget._clipBehavior,
//             ),
//           ),
//         ),
//       );
//
//   Widget buildItem(int index) => SliverList.list(
//         children: <Widget>[
//           RectGetter(
//             key: itemsKeys[index]!,
//             child: AutoScrollTag(
//               key: ValueKey<int>(index),
//               index: index,
//               controller: widget._autoScrollController,
//               child: widget._eachItemChild(
//                 widget._listItemData[index],
//                 index,
//               ),
//             ),
//           ),
//         ],
//       );
//
//   /// Animation Function for tabBarListener
//   /// This need to put inside TabBar onTap, but in this case we put inside tabBarListener
//   void animateAndScrollTo(int index) {
//     widget._tabController.animateTo(index);
//     switch (widget._verticalScrollPosition) {
//       case VerticalScrollPosition.begin:
//         widget._autoScrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
//       case VerticalScrollPosition.middle:
//         widget._autoScrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
//       case VerticalScrollPosition.end:
//         widget._autoScrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.end);
//     }
//   }
//
//   bool onScrollNotification(UserScrollNotification notification) {
//     final List<int> visibleItems = getVisibleItemsIndex();
//     if (visibleItems.isEmpty) {
//       return false;
//     }
//     if (notification.direction == ScrollDirection.reverse) {
//       return false;
//     }
//     widget._tabController.animateTo(visibleItems[0]);
//     return false;
//   }
//
//   List<int> getVisibleItemsIndex() {
//     final Rect? rect = RectGetter.getRectFromKey(listViewKey);
//     final List<int> items = <int>[];
//     if (rect == null) {
//       return items;
//     }
//
//     final bool isHorizontalScroll = widget._scrollDirection == Axis.horizontal;
//     itemsKeys.forEach(
//       (index, dynamic key) {
//         final Rect? itemRect = RectGetter.getRectFromKey(key);
//         if (itemRect == null) {
//           return;
//         }
//         switch (isHorizontalScroll) {
//           case true:
//             if (itemRect.left > rect.right) {
//               return;
//             }
//             if (itemRect.right < rect.left) {
//               return;
//             }
//           case false:
//             if (itemRect.top > rect.bottom) {
//               return;
//             }
//             if (itemRect.bottom < rect.top + MediaQuery.viewPaddingOf(context).top + kToolbarHeight + 56) {
//               return;
//             }
//         }
//         items.add(index);
//       },
//     );
//     return items;
//   }
//
//   void _handleTabControllerTick() {
//     if (VerticalScrollableTabBarStatus.isOnTap) {
//       VerticalScrollableTabBarStatus.isOnTap = false;
//       animateAndScrollTo(VerticalScrollableTabBarStatus.isOnTapIndex);
//     }
//   }
// }
