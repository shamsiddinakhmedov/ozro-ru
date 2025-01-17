// import 'package:flutter/material.dart';
// import 'package:ozro_mobile/src/core/constants/constants.dart';
// import 'package:ozro_mobile/src/core/extension/extension.dart';
// import 'package:ozro_mobile/src/core/formatters/upper_case_text_field.dart';
// import 'package:ozro_mobile/src/core/utils/utils.dart';
// import 'package:ozro_mobile/src/presentation/components/inputs/custom_text_field.dart';
// import 'package:ozro_mobile/src/presentation/components/inputs/masked_text_input_formatter.dart';
//
// class SerialCodeAndSerialNumberTextFields extends StatelessWidget {
//   const SerialCodeAndSerialNumberTextFields({
//     super.key,
//     required this.passportSeriesController,
//     required this.passportNumberController,
//     this.title,
//     this.showPassportSeriesError = false,
//     this.showPassportNumberError = false,
//     this.onPassportSeriesChanged,
//     this.onPassportNumberChanged,
//     this.maxPassportSeriesLength = 2,
//     this.numberPassportHint,
//     this.isEditProfile = false,
//   });
//
//   final String? title;
//   final TextEditingController? passportSeriesController;
//   final TextEditingController? passportNumberController;
//   final bool showPassportSeriesError;
//   final bool showPassportNumberError;
//   final ValueChanged<String?>? onPassportSeriesChanged;
//   final ValueChanged<String?>? onPassportNumberChanged;
//   final int maxPassportSeriesLength;
//   final String? numberPassportHint;
//   final bool isEditProfile;
//
//   @override
//   Widget build(BuildContext context) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 6),
//             child: Text(
//               title ?? context.tr(Dictionary.serialAndNumber),
//               style: TextStyle(
//                 fontSize: 12,
//                 height: 14 / 12,
//                 fontWeight: FontWeight.w400,
//                 color: context.color.darkGrey2,
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: CustomTextField(
//                   inputAction: TextInputAction.done,
//                   fillColor: context.color.disabled,
//                   keyboardType: TextInputType.name,
//                   inputFormatters: [
//                     MaskedTextInputFormatter(
//                       mask: List.generate(maxPassportSeriesLength, (index) => '#').join(),
//                       separator: '',
//                       filter: RegExp('[A-Za-z]'),
//                     ),
//                     UpperCaseTextFormatter(),
//                   ],
//                   filled: true,
//                   enabled: !isEditProfile,
//                   readOnly: isEditProfile,
//                   onChanged: onPassportSeriesChanged,
//                   errorText: context.tr(Dictionary.requiredField),
//                   showError: showPassportSeriesError,
//                   controller: passportSeriesController,
//                   hintText: context.tr(Dictionary.serial),
//                 ),
//               ),
//               AppUtils.kGap12,
//               Expanded(
//                 flex: 7,
//                 child: CustomTextField(
//                   inputAction: TextInputAction.done,
//                   fillColor: context.color.disabled,
//                   keyboardType: TextInputType.number,
//                   filled: true,
//                   enabled: !isEditProfile,
//                   readOnly: isEditProfile,
//                   inputFormatters: [
//                     MaskedTextInputFormatter(mask: '#######', separator: '', filter: RegExp('[0-9]')),
//                   ],
//                   onChanged: onPassportNumberChanged,
//                   errorText: context.tr(Dictionary.requiredField),
//                   showError: showPassportNumberError,
//                   controller: passportNumberController,
//                   hintText: numberPassportHint ?? context.tr(Dictionary.number),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
// }
