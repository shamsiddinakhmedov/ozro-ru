// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:ozro_mobile/src/core/constants/constants.dart';
// import 'package:ozro_mobile/src/core/extension/extension.dart';
// import 'package:ozro_mobile/src/core/utils/utils.dart';
//
// class CupertinoOnlyYearPickerBottomSheet extends StatefulWidget {
//   const CupertinoOnlyYearPickerBottomSheet({
//     super.key,
//     this.initialYear,
//     this.minimumYear,
//     this.maximumYear,
//     this.itemExtent = 32,
//   });
//
//   final int? initialYear;
//   final int? minimumYear;
//   final int? maximumYear;
//   final double itemExtent;
//
//   @override
//   State<CupertinoOnlyYearPickerBottomSheet> createState() => _CupertinoOnlyYearPickerBottomSheet();
// }
//
// class _CupertinoOnlyYearPickerBottomSheet extends State<CupertinoOnlyYearPickerBottomSheet> {
//   String initialValue = '';
//   late FixedExtentScrollController _controller;
//   final List<int> years = [];
//   int initialIndex = 0;
//   late int minYear = widget.minimumYear ?? DateTime.now().subtract(const Duration(days: 100 * 365)).year;
//   late int maxYear = widget.maximumYear ?? DateTime.now().year;
//
//   @override
//   void initState() {
//     _generateYear();
//     _controller = FixedExtentScrollController(initialItem: initialIndex);
//     super.initState();
//   }
//
//   void _generateYear() {
//     if (maxYear < minYear) {
//       final a = maxYear;
//       maxYear = minYear;
//       minYear = a;
//     }
//
//     for (int i = maxYear; i >= minYear; i--) {
//       years.add(i);
//     }
//
//     _getInitialIndex();
//
//     initialValue = years.firstOrNull.toString();
//   }
//
//   void _getInitialIndex() {
//     if (widget.initialYear != null && years.contains(widget.initialYear)) {
//       initialIndex = years.indexWhere((year) => year == widget.initialYear);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) => Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: AppUtils.kPaddingHorizontal16,
//             child: Text(
//               context.tr(Dictionary.vehicleManufactureYear),
//               style: context.textStyle.appBarTitle,
//             ),
//           ),
//           AppUtils.kGap16,
//           Expanded(
//             child: CupertinoPicker(
//               squeeze: .5,
//               diameterRatio: 1.5,
//               scrollController: _controller,
//               itemExtent: widget.itemExtent,
//               onSelectedItemChanged: (index) {
//                 initialValue = years[index].toString();
//               },
//               children: List.generate(
//                 years.length,
//                 (index) => Text('${years[index]}'),
//               ),
//             ),
//           ),
//           SafeArea(
//             minimum: AppUtils.kPaddingAll16,
//             child: ElevatedButton(
//               onPressed: () {
//                 context.pop(initialValue);
//               },
//               child: const Text(
//                 'Продолжить',
//               ),
//             ),
//           ),
//         ],
//       );
// }
