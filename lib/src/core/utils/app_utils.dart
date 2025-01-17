part of 'utils.dart';

sealed class AppUtils {
  AppUtils._();

  static const kSpacer = Spacer();

  static const kBox = SizedBox();

  static const kGap = Gap(0);
  static const kGap2 = Gap(2);
  static const kGap4 = Gap(4);
  static const kGap6 = Gap(6);
  static const kGap8 = Gap(8);
  static const kGap12 = Gap(12);
  static const kGap16 = Gap(16);
  static const kGap20 = Gap(20);
  static const kGap24 = Gap(24);
  static const kGap28 = Gap(28);
  static const kGap32 = Gap(32);
  static const kGap40 = Gap(40);

  /// sliverGap for CustomScrollView
  static const kSliverGap = SliverGap(0);
  static const kSliverGap4 = SliverGap(4);
  static const kSliverGap6 = SliverGap(6);
  static const kSliverGap8 = SliverGap(8);
  static const kSliverGap12 = SliverGap(12);
  static const kSliverGap16 = SliverGap(16);
  static const kSliverGap20 = SliverGap(20);
  static const kSliverGap24 = SliverGap(24);
  static const kSliverGap26 = SliverGap(26);
  static const kSliverGap28 = SliverGap(28);
  static const kSliverGap32 = SliverGap(32);
  static const kSliverGap40 = SliverGap(40);

  /// divider
  static const kDivider = Divider(height: 1);
  static const kDividerWithPaddingVer12 = Padding(padding: kPaddingVertical12, child: Divider(height: 1));
  static const kDividerWithPaddingVer4 = Padding(padding: kPaddingVertical4, child: Divider(height: 1));
  static const kDividerHor12 = Divider(height: 1, endIndent: 12, indent: 12);
  static const kDividerH0 = Divider(height: 0);
  static const kPadDividerLeft55Right16 = Divider(height: 1, endIndent: 16, indent: 55);
  static const kDividerWithPaddingHor16 = Padding(padding: kPaddingHorizontal16, child: Divider(height: 1));

  /// padding
  static const kPaddingZero = EdgeInsets.zero;
  static const kPaddingAll2 = EdgeInsets.all(2);
  static const kPaddingAll4 = EdgeInsets.all(4);
  static const kPaddingAll6 = EdgeInsets.all(6);
  static const kPaddingAll8 = EdgeInsets.all(8);
  static const kPaddingAll10 = EdgeInsets.all(10);
  static const kPaddingAll12 = EdgeInsets.all(12);
  static const kPaddingAll14 = EdgeInsets.all(14);
  static const kPaddingAll16 = EdgeInsets.all(16);
  static const kPaddingAll24 = EdgeInsets.all(24);
  static const kPaddingAll32 = EdgeInsets.all(32);
  static const kPaddingAll100 = EdgeInsets.all(100);
  static const kPaddingHorizontal4 = EdgeInsets.symmetric(horizontal: 4);
  static const kPaddingHorizontal6 = EdgeInsets.symmetric(horizontal: 6);
  static const kPaddingHorizontal12 = EdgeInsets.symmetric(horizontal: 12);
  static const kPaddingHorizontal16 = EdgeInsets.symmetric(horizontal: 16);
  static const kPaddingHorizontal24 = EdgeInsets.symmetric(horizontal: 24);
  static const kPaddingHorizontal36 = EdgeInsets.symmetric(horizontal: 36);
  static const kPaddingHor36Ver24 = EdgeInsets.symmetric(horizontal: 36, vertical: 24);
  static const kPaddingHor48Ver40 = EdgeInsets.symmetric(horizontal: 48, vertical: 40);
  static const kPaddingHorizontal8 = EdgeInsets.symmetric(horizontal: 8);
  static const kPaddingVertical8 = EdgeInsets.symmetric(vertical: 8);
  static const kPaddingVertical4 = EdgeInsets.symmetric(vertical: 4);
  static const kPaddingVertical2 = EdgeInsets.symmetric(vertical: 2);
  static const kPaddingVertical12 = EdgeInsets.symmetric(vertical: 12);
  static const kPaddingVertical16 = EdgeInsets.symmetric(vertical: 16);
  static const kPaddingVertical32 = EdgeInsets.symmetric(vertical: 32);
  static const kPaddingHor32Ver20 = EdgeInsets.symmetric(horizontal: 32, vertical: 20);
  static const kPaddingBottom16 = EdgeInsets.fromLTRB(0, 0, 0, 16);
  static const kPaddingBottom2 = EdgeInsets.fromLTRB(0, 0, 0, 2);
  static const kPaddingHor8Ver4 = EdgeInsets.symmetric(horizontal: 8, vertical: 10);
  static const kPaddingHor8Ver10 = EdgeInsets.symmetric(horizontal: 8, vertical: 10);
  static const kPaddingHor8Ver2 = EdgeInsets.symmetric(horizontal: 8, vertical: 2);
  static const kPaddingHor14Ver16 = EdgeInsets.symmetric(horizontal: 14, vertical: 16);
  static const kPaddingHor14Ver12 = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  static const kPaddingHor16Ver12 = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const kPaddingHor16Ver4 = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
  static const kPaddingHor16Ver10 = EdgeInsets.symmetric(horizontal: 16, vertical: 10);
  static const kPaddingHor16Ver7 = EdgeInsets.symmetric(horizontal: 16, vertical: 7);
  static const kPaddingHor12Ver8 = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const kPaddingHor12Ver10 = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
  static const kPaddingHor12Ver16 = EdgeInsets.symmetric(horizontal: 12, vertical: 16);
  static const kPaddingHor16Ver24 = EdgeInsets.symmetric(horizontal: 16, vertical: 24);
  static const kPaddingHor16Ver32 = EdgeInsets.symmetric(horizontal: 16, vertical: 32);
  static const kPaddingTop8Bottom4 = EdgeInsets.only(top: 8, bottom: 4);
  static const kPaddingTop4Bottom8 = EdgeInsets.only(top: 8, bottom: 4);
  static const kPaddingTop30Right40 = EdgeInsets.only(top: 30, right: 40);
  static const kPaddingTop0All16 = EdgeInsets.only(left: 16, right: 16, bottom: 16);
  static const kPaddingRight40 = EdgeInsets.only(right: 40);
  static const kPaddingLeft40 = EdgeInsets.only(left: 40);
  static const kPaddingLeft50 = EdgeInsets.only(left: 50);
  static const kPaddingLeft30 = EdgeInsets.only(left: 30);
  static const kPaddingLeft12 = EdgeInsets.only(left: 12);
  static const kPaddingLeft8 = EdgeInsets.only(left: 8);
  static const kPaddingLeft16 = EdgeInsets.only(left: 16);
  static const kPaddingRight16 = EdgeInsets.only(right: 16);
  static const kPaddingRight12 = EdgeInsets.only(right: 12);
  static const kPaddingTop16 = EdgeInsets.only(top: 16);
  static const kPaddingHor16Bottom12 = EdgeInsets.only(left: 16, right: 16, bottom: 12);

  static const kPaddingAllB16 = EdgeInsets.fromLTRB(16, 16, 16, 0);
  static const kPaddingAllT16 = EdgeInsets.fromLTRB(16, 0, 16, 16);
  static const kPaddingAllH16T4B16 = EdgeInsets.fromLTRB(16, 4, 16, 16);

  /// border radius
  static const kRadius = Radius.zero;
  static const kRadius6 = Radius.circular(6);
  static const kRadius16 = Radius.circular(16);
  static const kRadius12 = Radius.circular(12);
  static const kBorderRadius0 = BorderRadius.zero;
  static const kBorderRadius2 = BorderRadius.all(Radius.circular(2));
  static const kBorderRadius4 = BorderRadius.all(Radius.circular(4));
  static const kBorderRadius6 = BorderRadius.all(Radius.circular(6));
  static const kBorderRadius8 = BorderRadius.all(Radius.circular(8));
  static const kBorderRadius10 = BorderRadius.all(Radius.circular(10));
  static const kBorderRadius12 = BorderRadius.all(Radius.circular(12));
  static const kBorderRadius16 = BorderRadius.all(Radius.circular(16));
  static const kBorderRadius18 = BorderRadius.all(Radius.circular(18));
  static const kBorderRadius50 = BorderRadius.all(Radius.circular(50));
  static const kBorderRadius52 = BorderRadius.all(Radius.circular(52));
  static const kBorderRadiusOnlyTop16 = BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16));
  static const kBorderRadiusOnlyTop12 = BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12));
  static const kBorderRadiusOnlyBottom16 =
      BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16));
  static const kBorderRadiusOnlyBottom12 =
      BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12));
  static const kBorderRadius100 = BorderRadius.all(Radius.circular(100));
  static const kShapeRoundedNone = RoundedRectangleBorder();
  static const kShapeRoundedAll16 = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16),
    ),
  );
  static const kShapeRoundedAll12 = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  );
  static const kShapeRoundedAll10 = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  );
  static const kShapeRoundedBottom12 = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    ),
  );
}
